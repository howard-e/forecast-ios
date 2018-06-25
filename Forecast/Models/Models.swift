//
//  Models.swift
//  Forecast
//
//  Created by Howard Edwards on 6/24/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import Foundation

class Forecast {
	var timestamp: Double
	var temperature: Double
	var weatherStatusIcon: String
	var weatherCondition: String
	
	init(timestamp: Double, temperature: Double, weatherStatusIcon: String, weatherCondition: String) {
		self.timestamp = timestamp
		self.temperature = temperature
		self.weatherStatusIcon = weatherStatusIcon
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
}
