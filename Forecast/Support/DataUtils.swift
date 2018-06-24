//
//  DataUtils.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift
import SwiftEventBus


// MARK :- Properties
let httpManager = HttpManager.shared
let forecastLocationManger = ForecastLocationManager.shared

let firestoreDb = (UIApplication.shared.delegate as! AppDelegate).db


// MARK :- API Methods
func getWeatherInfo(controller: UIViewController, successSegue: String? = nil, refresh: Bool = false) {
	let latestCoordinates = getUserDefaults(any: UserDefaultsKeys.lastestCoordinates) as? [String: Any] ?? [:]
	let resourceUrl = getOpenWeatherMapApiForCurrentLocationEndpoint(weatherApiRequestType: .weather, latitude: latestCoordinates["lat"] as? String ?? "", longitude: latestCoordinates["lon"] as? String ?? "")
	logRequestInfo(#function, resourceUrl)
	
	showActivityIndicator(true)
	httpManager.get(url: resourceUrl) { response in
		showActivityIndicator(false)
		print("\(#function) [REQUEST]: \(response.response?.url?.absoluteString ?? "")")
		
		if let responseData = response.result.value {
			print("\(#function) [RESPONSE]: \(responseData)")
			
			let code = JSON(responseData)["cod"].intValue
			switch code {
			case 200:
				let mainInfo = JSON(responseData)["main"]
				let windInfo = JSON(responseData)["wind"]
				let generalInfo = JSON(responseData)["sys"]
				let rainInfo = JSON(responseData)["rain"]
				let conditionInfo = JSON(responseData)["weather"]
				
				let temperature = mainInfo["temp"].doubleValue
				let pressure = mainInfo["pressure"].doubleValue
				let humidity = mainInfo["humidity"].doubleValue
				
				let windSpeed = windInfo["speed"].doubleValue
				let windDirection = windInfo["deg"].doubleValue
				
				let locationName = JSON(responseData)["name"].stringValue
				let locationCountryCode = generalInfo["country"].stringValue
				let locationSunrise = generalInfo["sunrise"].doubleValue
				let locationSunset = generalInfo["sunset"].doubleValue
				
				let precipitation = rainInfo["3h"].doubleValue
				
				var weatherIcon = ""
				var weatherCondition = ""
				for weather in conditionInfo.arrayValue {
					if let weatherConditionInfo = weather.dictionary {
						weatherIcon = weatherConditionInfo["icon"]?.stringValue ?? ""
						weatherCondition = weatherConditionInfo["main"]?.stringValue ?? ""
					}
					break
				}
				
				let weatherInfo: [String: Any] = [
					"temperature": temperature,
					"pressure": pressure,
					"humidity": humidity,
					"wind_speed": windSpeed,
					"wind_direction": windDirection,
					"location_name": locationName,
					"country_code": locationCountryCode,
					"sunrise": locationSunrise,
					"sunset": locationSunset,
					"precipitation": precipitation,
					"weather_status_icon": weatherIcon,
					"weather_condition": weatherCondition
				]
				
				setUserDefaults(any: weatherInfo, key: UserDefaultsKeys.todayWeatherInfo)
				
				if refresh {
					SwiftEventBus.post(EventBusParams.refreshTodayWeatherInfo)
				}
				
				let deviceId = getUserDefaults(string: UserDefaultsKeys.deviceId) ?? ""
				firestoreDb?.collection(deviceId).document("weather_info").setData(weatherInfo) { error in
					if error != nil { // Handle error
					} else { // Successfully written
					}
				}
				
				if let successSegue = successSegue {
					setUserDefaults(bool: true, key: UserDefaultsKeys.seenOnboarding)
					controller.performSegue(withIdentifier: successSegue, sender: nil)
				}
				break
			case 400:
				controller.alert(message: "Unable to retrieve current location's weather information. Please try again later", title: "Error", customHandler: { _ in
					if let successSegue = successSegue {
						setUserDefaults(bool: true, key: UserDefaultsKeys.seenOnboarding)
						controller.performSegue(withIdentifier: successSegue, sender: nil)
					}
				})
				break
			default:
				controller.alert(message: "Something went wrong. Unable to retrieve current location's weather information. Please try again later", title: "Error", customHandler: { _ in
					if let successSegue = successSegue {
						setUserDefaults(bool: true, key: UserDefaultsKeys.seenOnboarding)
						controller.performSegue(withIdentifier: successSegue, sender: nil)
					}
				})
				break
			}
		} else {
			if let error = (response.error as NSError?) {
				switch error.code {
				case -1009:
					controller.alert(message: "Please reconnect and try again.", title: "Internet Connection Required")
					break
				default:
					controller.alert(message: "Something went wrong. Please try again.", title: "Error")
					break
				}
			}
		}
	}
}

func getFiveDayForcecast(controller: UIViewController) {
	let latestCoordinates = getUserDefaults(any: UserDefaultsKeys.lastestCoordinates) as? [String: Any] ?? [:]
	let resourceUrl = getOpenWeatherMapApiForCurrentLocationEndpoint(weatherApiRequestType: .forecast, latitude: latestCoordinates["lat"] as? String ?? "", longitude: latestCoordinates["lon"] as? String ?? "")
	logRequestInfo(#function, resourceUrl)
	
	showActivityIndicator(true)
	httpManager.get(url: resourceUrl) { response in
		showActivityIndicator(false)
		print("\(#function) [REQUEST]: \(response.response?.url?.absoluteString ?? "")")
		
		if let responseData = response.result.value {
			print("\(#function) [RESPONSE]: \(responseData)")
			
			let code = JSON(responseData)["cod"].intValue
			switch code {
			case 200:
				var forecastData = [[String: Any]]()
				
				let forecastList = JSON(responseData)["list"]
				let cityInfo = JSON(responseData)["city"]
				
				let locationName = cityInfo["name"].stringValue
				
				for forecast in forecastList.arrayValue {
					if let forecastItem = forecast.dictionary {
						let mainInfo = JSON(forecastItem)["main"]
						let conditionInfo = JSON(forecastItem)["weather"]
						
						let temperature = mainInfo["temp"].doubleValue
						
						var weatherIcon = ""
						var weatherCondition = ""
						for weather in conditionInfo.arrayValue {
							if let weatherConditionInfo = weather.dictionary {
								weatherIcon = weatherConditionInfo["icon"]?.stringValue ?? ""
								weatherCondition = weatherConditionInfo["main"]?.stringValue ?? ""
							}
							break
						}
						
						let dateTimestamp = forecastItem["dt"]?.doubleValue ?? -1
						
						let forecastDataItem: [String: Any] = [
							"timestamp": dateTimestamp,
							"temperature": temperature,
							"weather_status_icon": weatherIcon,
							"weather_condition": weatherCondition
						]
						
						forecastData.append(forecastDataItem)
					}
				}
				
				let forecastObject: [String: Any] = [
					"location_name": locationName,
					"forecast_data": forecastData
				]
				
				let deviceId = getUserDefaults(string: UserDefaultsKeys.deviceId) ?? ""
				firestoreDb?.collection(deviceId).document("forecast_info").setData(forecastObject) { error in
					if error != nil { // Handle error
					} else { // Successfully written
					}
				}
				
				setUserDefaults(any: forecastObject, key: UserDefaultsKeys.forecastInfo)
				SwiftEventBus.post(EventBusParams.forecastWeatherInfo, sender: true)
				break
			default:
				SwiftEventBus.post(EventBusParams.forecastWeatherInfo, sender: false)
				controller.alert(message: "Something went wrong. Unable to retrieve current location's weather information. Please try again later", title: "Error")
			}
		} else {
			SwiftEventBus.post(EventBusParams.forecastWeatherInfo, sender: false)
			if let error = (response.error as NSError?) {
				switch error.code {
				case -1009:
					controller.alert(message: "Please reconnect and try again.", title: "Internet Connection Required")
					break
				default:
					controller.alert(message: "Something went wrong. Please try again.", title: "Error")
					break
				}
			}
		}
	}
}


// MARK :- Utility Methods
func getOpenWeatherMapApiForCurrentLocationEndpoint(weatherApiRequestType requestType: OpenWeatherMapRequestType, latitude lat: String, longitude lon: String) -> String {
	return "\(URLs.OPEN_WEATHER_BASE_API)\(requestType.rawValue)?lat=\(lat)&lon=\(lon)&APPID=\(Constants.OPEN_WEATHER_MAP_API_KEY)&units=metric"
}

func logRequestInfo(_ requestTitle: String, _ requestUrl: String, requestParams: [String: Any]? = nil, headers: HTTPHeaders? = nil) {
	print("======= \(requestTitle) =======")
	print("requestUrl: \(requestUrl)")
	if requestParams != nil {
		print("requestParams: \(requestParams ?? [:])")
	}
	if headers != nil {
		print("headers: \(headers ?? [:])")
	}
	print("==============")
}
