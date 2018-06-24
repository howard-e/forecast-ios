//
//  TodayViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftEventBus

class TodayViewController: UIViewController {
	
	@IBOutlet weak var weatherStatusIndicatorImageView: UIImageView!
	@IBOutlet weak var temperatureWeatherConditionLabel: UILabel!
	@IBOutlet weak var currentLocationButton: UIButton!
	
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var precipitationLabel: UILabel!
	@IBOutlet weak var pressureLabel: UILabel!
	@IBOutlet weak var windSpeedLabel: UILabel!
	@IBOutlet weak var windDirectionLabel: UILabel!
	
	var weatherInfoRequested = false
	var canRequestWeatherInfo = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUp()
	}

	func setUp() {
		// Views Set Up
		currentLocationButton.titleLabel?.numberOfLines = 0
		
		refreshTodayWeatherInfo()
		SwiftEventBus.onMainThread(self, name: EventBusParams.refreshTodayWeatherInfo) { result in
			self.refreshTodayWeatherInfo()
		}
	}
	
	func refreshTodayWeatherInfo() {
		let todayWeatherInfo = getUserDefaults(any: UserDefaultsKeys.todayWeatherInfo) as! [String: Any]
		
		let locationName = todayWeatherInfo["location_name"] as? String ?? "N/A"
		let countryCode = todayWeatherInfo["country_code"] as? String ?? "US"
		let country = Locale.current.localizedString(forRegionCode: countryCode) ?? "N/A"
		currentLocationButton.setTitle("\(locationName)\(country != "N/A" ? ", \(country)" : "")", for: .normal)
		
		let temperature = todayWeatherInfo["temperature"] as? Double ?? -1
		let weatherCondition = todayWeatherInfo["weather_condition"] as? String ?? "N/A"
		temperatureWeatherConditionLabel.text = "\(temperature)°C\(weatherCondition != "N/A" ? " | \(weatherCondition)" : "")"
		
		let pressure = todayWeatherInfo["pressure"] as? Double ?? -1
		let humidity = todayWeatherInfo["humidity"] as? Double ?? -1
		let windSpeed = todayWeatherInfo["wind_speed"] as? Double ?? -1
		let precipitation = todayWeatherInfo["precipitation"] as? Double ?? 0.0
		let windDirection = todayWeatherInfo["wind_direction"] as? Double ?? -1
		pressureLabel.text = "\(pressure) hPa"
		humidityLabel.text = "\(humidity)%"
		precipitationLabel.text = "\(precipitation) mm"
		windSpeedLabel.text = "\(windSpeed) km/h"
		windDirectionLabel.text = "\(compassDirection(for: windDirection) ?? "N/A")"
		
		let weatherConditionIcon = todayWeatherInfo["weather_status_icon"] as? String ?? ""
		let condition = evaluateWeatherCondition(weatherConditionIcon)
		
		if let condition = condition, let time = weatherConditionIcon.last {
			switch time {
			case "d":
				weatherStatusIndicatorImageView.image = Constants.WEATHER_CONDITION_IMAGE_DAY[condition]
			case "n":
				weatherStatusIndicatorImageView.image = Constants.WEATHER_CONDITION_IMAGE_NIGHT[condition]
			default:
				break
			}
		}
	}
	
	func compassDirection(for heading: CLLocationDirection) -> String? {
		if heading < 0 { return nil }
		
		let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
		let index = Int((heading + 22.5) / 45.0) & 7
		return directions[index]
	}
	
	func evaluateWeatherCondition(_ weatherConditionIcon: String) -> WeatherCondition? {
		for condition in WeatherCondition.allValues {
			if weatherConditionIcon.contains(condition.rawValue) {
				return condition
			}
		}
		return nil
	}
	
	@IBAction func setCurrentLocation(_ sender: Any) {
		weatherInfoRequested = false
		canRequestWeatherInfo = true
		
		forecastLocationMangaer.delegate = self
		forecastLocationMangaer.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .restricted:
				self.alert(message: "Unable to access Location. \"Forecast\" is not authorized to do so.", title: "Restricted")
				break
			case .denied:
				self.alert(message: "Please allow access if you want to use this feature.\nGo to 'Settings -> Privacy -> Location Services -> \"Forecast\" -> Allow Location Access for \"Forecast\".", title: "Access Denied", otherActionTitle: "Go To Settings") { _ in
					guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
						self.alert(message: "Unable to open App's Settings", title: "Error")
						return
					}
					
					if UIApplication.shared.canOpenURL(settingsUrl) {
						UIApplication.shared.open(settingsUrl, completionHandler: { success in
							print("Settings opened: \(success)")
						})
					}
				}
				break
			default:
				forecastLocationMangaer.startUpdatingLocation()
				break
			}
		} else {
			self.alert(message: "", title: "Turn On Location Services to Allow \"Forecast\" to Determine Your Location")
		}
	}
	
	@IBAction func shareWeatherInfo(_ sender: Any) {
	}
}

extension TodayViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .restricted:
			self.alert(message: "Unable to access Location. \"Forecast\" is not authorized to do so.", title: "Restricted")
			break
		case .denied:
			self.alert(message: "Please allow access if you want to use this feature.\nGo to 'Settings -> Privacy -> Location Services -> \"Forecast\" -> Allow Location Access for \"Forecast\".", title: "Access Denied", otherActionTitle: "Go To Settings") { _ in
				guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
					self.alert(message: "Unable to open App's Settings", title: "Error")
					return
				}
				
				if UIApplication.shared.canOpenURL(settingsUrl) {
					UIApplication.shared.open(settingsUrl, completionHandler: { success in
						print("Settings opened: \(success)")
					})
				}
			}
			break
		default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// Get user coordinates; check OpenWeatherApi route; go to dashboard
		if locations.count > 0, let currentLocation = locations.last {
			forecastLocationMangaer.stopUpdatingLocation()
			
			weatherInfoRequested = true
			if canRequestWeatherInfo && weatherInfoRequested {
				canRequestWeatherInfo = false
				print("Current Location: \(currentLocation)")
				
				let params: [String: Any] = [
					"lat": String(currentLocation.coordinate.latitude),
					"lon": String(currentLocation.coordinate.longitude)
				]
				
				let deviceId = getUserDefaults(string: UserDefaultsKeys.deviceId) ?? ""
				firestoreDb?.collection(deviceId).document("coordinates").setData(params) { error in
					if let error = error {
						print("Error writing document: \(error)")
					} else {
						print("Document successfully written!")
					}
				}
				
				getWeatherInfo(controller: self, params: params, refresh: true)
			}
		}
	}
}
