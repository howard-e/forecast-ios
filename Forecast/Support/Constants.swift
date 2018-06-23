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
}

struct Colors {
	static let textBlue = UIColor(hexString: "#2F91FF")
	static let textOrange = UIColor(hexString: "#FF8847")
}

struct XibCells {
	static let forecastCell = "ForecastTableViewCell"
}

struct CellIdentifiers {
	static let forecastCell = "ForecastTableViewCell"
}
