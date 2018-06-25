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
		
		refreshTodayWeatherInfo() // Set 'Today' information with already saved information if available
		
		// To get the latest information with the user's current location
		forecastLocationManger.startUpdatingLocation(controller: self, completionAction: {
			getWeatherInfo(controller: self, refresh: true)
		})
		
		SwiftEventBus.onMainThread(self, name: EventBusParams.refreshTodayWeatherInfo) { result in
			self.refreshTodayWeatherInfo() // reload 'Today' information after getWeatherInfo route triggers call
		}
	}
	
	func refreshTodayWeatherInfo() {
		// TODO: Pull from Firebase if unavailable
		let todayWeatherInfo = getUserDefaults(any: UserDefaultsKeys.todayWeatherInfo) as! [String: Any]
		
		let locationName = todayWeatherInfo["location_name"] as? String ?? "N/A"
		let countryCode = todayWeatherInfo["country_code"] as? String ?? "US"
		let temperature = todayWeatherInfo["temperature"] as? Double ?? -1
		let weatherCondition = todayWeatherInfo["weather_condition"] as? String ?? "N/A"
		let pressure = todayWeatherInfo["pressure"] as? Double ?? -1
		let humidity = todayWeatherInfo["humidity"] as? Double ?? -1
		let windSpeed = todayWeatherInfo["wind_speed"] as? Double ?? -1
		let precipitation = todayWeatherInfo["precipitation"] as? Double ?? 0.0
		let windDirection = todayWeatherInfo["wind_direction"] as? Double ?? -1
		let weatherConditionIcon = todayWeatherInfo["weather_status_icon"] as? String ?? ""
		let sunrise = todayWeatherInfo["sunrise"] as? Double ?? -1
		let sunset = todayWeatherInfo["sunset"] as? Double ?? -1
		
		let todayWeather = TodayWeather(locationName: locationName, countryCode: countryCode, weatherCondition: weatherCondition, weatherConditionIcon: weatherConditionIcon, temperature: temperature, pressure: pressure, humidity: humidity, precipitation: precipitation, windSpeed: windSpeed, windDirection: windDirection, sunrise: sunrise, sunset: sunset)
		
		
		currentLocationButton.setTitle(todayWeather.getCurrentLocation(), for: .normal)
		temperatureWeatherConditionLabel.text = todayWeather.getTempWeatherCondition()
		pressureLabel.text = "\(String(format: "%.0f", todayWeather.pressure)) hPa"
		humidityLabel.text = "\(String(format: "%.0f", todayWeather.humidity))%"
		precipitationLabel.text = "\(String(format: "%.1f", todayWeather.precipitation)) mm"
		windSpeedLabel.text = "\(String(format: "%.2f", todayWeather.windSpeed)) km/h"
		windDirectionLabel.text = "\(todayWeather.getCompassDirection() ?? "N/A")"
		weatherStatusIndicatorImageView.image = todayWeather.getWeatherStatusIcon()
	}
	
	
	// MARK :- Actions
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
		
		activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
			if activityError != nil {
				self.alert(message: "Something went wrong when trying to share. Please try again.", title: "Error")
				return
			}
			completed ? self.alert(message: "Successfully Shared!") : self.alert(message: "Sharing Cancelled")
		}
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	@IBAction func seeInfo(_ sender: Any) {
		self.alert(message: "Tap your location at any time to refresh.", title: "Help")
	}
}
