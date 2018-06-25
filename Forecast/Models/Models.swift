//
//  Models.swift
//  Forecast
//
//  Created by Howard Edwards on 6/24/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

class TodayWeather {
	var locationName: String
	var countryCode: String
	var weatherCondition: String
	var weatherConditionIcon: String
	
	var temperature: Double
	var pressure: Double
	var humidity: Double
	var precipitation: Double
	var windSpeed: Double
	var windDirection: Double
	var sunrise: Double
	var sunset: Double
	
	init(locationName: String, countryCode: String, weatherCondition: String, weatherConditionIcon: String, temperature: Double, pressure: Double, humidity: Double, precipitation: Double, windSpeed: Double, windDirection: Double, sunrise: Double, sunset: Double) {
		self.locationName = locationName
		self.countryCode = countryCode
		self.weatherCondition = weatherCondition
		self.weatherConditionIcon = weatherConditionIcon
		self.temperature = temperature
		self.pressure = pressure
		self.humidity = humidity
		self.precipitation = precipitation
		self.windSpeed = windSpeed
		self.windDirection = windDirection
		self.sunset = sunset
		self.sunrise = sunrise
	}
	
	func getCurrentLocation() -> String {
		let country = Locale.current.localizedString(forRegionCode: countryCode) ?? "N/A"
		return "\(locationName)\(country != "N/A" ? ", \(country)" : "")"
	}
	
	func getTempWeatherCondition() -> String {
		return "\(String(format: "%.0f", temperature))°C\(weatherCondition != "N/A" ? " | \(weatherCondition)" : "")"
	}
	
	func getWeatherStatusIcon() -> UIImage? {
		let condition = WeatherCondition.evaluateWeatherCondition(weatherConditionIcon)
		// TODO: If Location Services Unavailable; OpenWeatherMapApi Unavailable, get model from Firebase; check sunrise/sunset to determine time instead of saved icon
		if let condition = condition, let time = weatherConditionIcon.last { // time here refers to the d = day and n = n on the end of the weather status icon string returned from the OpenWeatherMap API
			switch time {
			case "d":
				return Constants.WEATHER_CONDITION_IMAGE_DAY[condition]
			case "n":
				return Constants.WEATHER_CONDITION_IMAGE_NIGHT[condition]
			default:
				return nil
			}
		}
		return nil
	}
	
	func getCompassDirection() -> String? {
		if windDirection < 0 { return nil }
		
		let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
		let index = Int((windDirection + 22.5) / 45.0) & 7
		return directions[index]
	}
}

class Forecast {
	var timestamp: Double
	var temperature: Double
	var weatherConditionIcon: String
	var weatherCondition: String
	
	init(timestamp: Double, temperature: Double, weatherConditionIcon: String, weatherCondition: String) {
		self.timestamp = timestamp
		self.temperature = temperature
		self.weatherConditionIcon = weatherConditionIcon
		self.weatherCondition = weatherCondition
	}
	
	// Meant to return HH:MM format for time of forecast
	func getTimeOfDay() -> String {
		let forecastDate = Date(timeIntervalSince1970: timestamp)
		
		let components = Calendar.current.dateComponents([.hour, .minute], from: forecastDate)
		return "\(String(format: "%02d", components.hour ?? 00)):\(String(format: "%02d", components.minute ?? 00))"
	}
	
	// Meant to return 'MONDAY', 'TUESDAY' etc of forecast
	func weekday() -> String {
		let currentDate = Date()
		let forecastDate = Date(timeIntervalSince1970: timestamp)
		
		if Calendar.current.isDateInToday(forecastDate) {
			return "TODAY"
		} else if Calendar.current.isDateInYesterday(forecastDate) { // In the instance where data isn't uploaded in time
			return "YESTERDAY"
		} else if forecastDate < currentDate { // fallback
			return "PAST DAY"
		} else {
			return DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: forecastDate) - 1].uppercased()
		}
	}
	
	func getWeatherStatusIcon() -> UIImage? {
		let condition = WeatherCondition.evaluateWeatherCondition(weatherConditionIcon)
		if let condition = condition, let time = weatherConditionIcon.last { // time here refers to the d = day and n = n on the end of the weather status icon string returned from the OpenWeatherMap API
			switch time {
			case "d":
				return Constants.WEATHER_CONDITION_IMAGE_DAY[condition]
			case "n":
				return Constants.WEATHER_CONDITION_IMAGE_NIGHT[condition]
			default:
				return nil
			}
		}
		return nil
	}
}
