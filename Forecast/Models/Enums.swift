//
//  Enums.swift
//  Forecast
//
//  Created by Howard Edwards on 6/23/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

enum WeatherCondition: String {
	case brokenClouds = "04"
	case clearSky = "01"
	case fewClouds = "02"
	case mist = "50"
	case rain = "10"
	case scatteredClouds = "03"
	case showerRain = "09"
	case snow = "13"
	case thunderstorm = "11"
	
	static let allValues = [brokenClouds, clearSky, fewClouds, mist, rain, scatteredClouds, showerRain, snow, thunderstorm]
	
	// returns the WeatherCondition case if weatherConditionIcon String contains any of those conditions' values; these values are from the OpenWeatherMap API
	static func evaluateWeatherCondition(_ weatherConditionIcon: String) -> WeatherCondition? {
		for condition in allValues {
			if weatherConditionIcon.contains(condition.rawValue) {
				return condition
			}
		}
		return nil
	}
}

enum OpenWeatherMapRequestType: String {
	case weather = "weather"
	case forecast = "forecast"
}
