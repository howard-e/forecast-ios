//
//  Constants.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

struct URLs {
	static let OPEN_WEATHER_BASE_API = "http://api.openweathermap.org/data/2.5/"
}

struct Constants {
	static let SERVER_TIMEOUT = 15.0
	static let OPEN_WEATHER_MAP_API_KEY = "445c9575570ef9b9b382f8fbe365b67c"
	
	static let WEATHER_CONDITION_IMAGE_DAY: [WeatherCondition: UIImage] = [
		.brokenClouds: #imageLiteral(resourceName: "BrokenCloudsDay"),
		.clearSky: #imageLiteral(resourceName: "ClearSkyDay"),
		.fewClouds: #imageLiteral(resourceName: "FewCloudsDay"),
		.mist: #imageLiteral(resourceName: "MistDay"),
		.rain: #imageLiteral(resourceName: "RainDay"),
		.scatteredClouds: #imageLiteral(resourceName: "ScatteredCloudsDay"),
		.showerRain: #imageLiteral(resourceName: "ShowerRainDay"),
		.snow: #imageLiteral(resourceName: "SnowDay"),
		.thunderstorm: #imageLiteral(resourceName: "ThunderstormDay")
	]
	
	static let WEATHER_CONDITION_IMAGE_NIGHT: [WeatherCondition: UIImage] = [
		.brokenClouds: #imageLiteral(resourceName: "BrokenCloudsNight"),
		.clearSky: #imageLiteral(resourceName: "ClearSkyNight"),
		.fewClouds: #imageLiteral(resourceName: "FewCloudsNight"),
		.mist: #imageLiteral(resourceName: "MistNight"),
		.rain: #imageLiteral(resourceName: "RainNight"),
		.scatteredClouds: #imageLiteral(resourceName: "ScatteredCloudsNight"),
		.showerRain: #imageLiteral(resourceName: "ShowerRainNight"),
		.snow: #imageLiteral(resourceName: "SnowNight"),
		.thunderstorm: #imageLiteral(resourceName: "ThunderstormNight")
	]
}

struct Colors {
	static let textBlue = UIColor(hexString: "#2F91FF")
	static let textOrange = UIColor(hexString: "#FF8847")
}

struct SegueIdentifiers {
	static let toDashboard = "goToDashboard"
}

struct XibCells {
	static let forecastCell = "ForecastTableViewCell"
	static let customHeaderCell = "CustomHeaderTableViewCell"
}

struct CellIdentifiers {
	static let forecastCell = "ForecastTableViewCell"
	static let customHeaderCell = "CustomHeaderTableViewCell"
}

struct ControllerIdentifiers {
	static let onboardingController = "OnboardingViewController"
	static let dashboardTabController = "DashboardTabBarController"
}

struct UserDefaultsKeys {
	static let deviceId = "device_id"
	static let todayWeatherInfo = "today_weather_info"
	static let seenOnboarding = "seen_onboarding"
}

struct EventBusParams {
	static let refreshTodayWeatherInfo = "refresh_today_weather_info"
}
