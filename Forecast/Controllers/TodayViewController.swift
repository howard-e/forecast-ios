//
//  TodayViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
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
		// TODO: Pull from Firebase if unavailable
		let todayWeatherInfo = getUserDefaults(any: UserDefaultsKeys.todayWeatherInfo) as! [String: Any]
		
		let locationName = todayWeatherInfo["location_name"] as? String ?? "N/A"
		let countryCode = todayWeatherInfo["country_code"] as? String ?? "US"
		let country = Locale.current.localizedString(forRegionCode: countryCode) ?? "N/A"
		currentLocationButton.setTitle("\(locationName)\(country != "N/A" ? ", \(country)" : "")", for: .normal)
		
		let temperature = todayWeatherInfo["temperature"] as? Double ?? -1
		let weatherCondition = todayWeatherInfo["weather_condition"] as? String ?? "N/A"
		temperatureWeatherConditionLabel.text = "\(String(format: "%.0f", temperature))°C\(weatherCondition != "N/A" ? " | \(weatherCondition)" : "")"
		
		let pressure = todayWeatherInfo["pressure"] as? Double ?? -1
		let humidity = todayWeatherInfo["humidity"] as? Double ?? -1
		let windSpeed = todayWeatherInfo["wind_speed"] as? Double ?? -1
		let precipitation = todayWeatherInfo["precipitation"] as? Double ?? 0.0
		let windDirection = todayWeatherInfo["wind_direction"] as? Double ?? -1
		pressureLabel.text = "\(String(format: "%.0f", pressure)) hPa"
		humidityLabel.text = "\(String(format: "%.0f", humidity))%"
		precipitationLabel.text = "\(String(format: "%.1f", precipitation)) mm"
		windSpeedLabel.text = "\(String(format: "%.2f", windSpeed)) km/h"
		windDirectionLabel.text = "\(compassDirection(for: windDirection) ?? "N/A")"
		
		let weatherConditionIcon = todayWeatherInfo["weather_status_icon"] as? String ?? ""
		let condition = WeatherCondition.evaluateWeatherCondition(weatherConditionIcon)
		
		// TODO: If Location Services Unavailable; OpenWeatherMapApi Unavailable, get model from Firebase; check sunrise/sunset to determine time instead of saved icon
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
	
	func compassDirection(for heading: Double) -> String? {
		if heading < 0 { return nil }
		
		let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
		let index = Int((heading + 22.5) / 45.0) & 7
		return directions[index]
	}
	
	@IBAction func setCurrentLocation(_ sender: Any) {
		forecastLocationManger.startUpdatingLocation(controller: self, completionAction: {
			getWeatherInfo(controller: self, refresh: true)
		})
	}
	
	@IBAction func shareWeatherInfo(_ sender: Any) {
		let todayWeatherInfo = getUserDefaults(any: UserDefaultsKeys.todayWeatherInfo) as! [String: Any]
		
		let locationName = todayWeatherInfo["location_name"] as? String ?? "N/A"
		let temperature = todayWeatherInfo["temperature"] as? Double ?? -1
		let weatherCondition = todayWeatherInfo["weather_condition"] as? String ?? "N/A"
		let weatherConditionMessage = "Hey! It's \(String(format: "%.0f", temperature))°C in \(locationName)!\nWeather Condition? \(weatherCondition)."
		
		let activityViewController = UIActivityViewController(activityItems: [weatherStatusIndicatorImageView.image ?? UIImage(named: "SplashIcon")!, weatherConditionMessage], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		activityViewController.excludedActivityTypes = [.airDrop]
		
		activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
			if activityError != nil {
				self.alert(message: "Something went wrong when trying to share. Please try again.", title: "Error")
				return
			}
			completed ? self.alert(message: "Successfully Shared!") : self.alert(message: "Sharing Cancelled")
		}
		self.present(activityViewController, animated: true, completion: nil)
	}
}
