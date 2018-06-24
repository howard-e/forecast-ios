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
}
