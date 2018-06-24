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
let forecastLocationMangaer = (UIApplication.shared.delegate as! AppDelegate).locationManager
let firestoreDb = (UIApplication.shared.delegate as! AppDelegate).db


// MARK :- API Methods
func getWeatherInfo(controller: UIViewController, params: [String: Any], successSegue: String? = nil, refresh: Bool = false) {
	let resourceUrl = getOpenWeatherMapApiForCurrentLocationEndpoint(latitude: params["lat"] as? String ?? "", longitude: params["lon"] as? String ?? "")
	logRequestInfo(#function, resourceUrl, requestParams: params)
	
	showActivityIndicator(true)
	httpManager.get(url: resourceUrl, completion: { (response: DataResponse<Any>) -> () in
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
					if let error = error {
						print("Error writing document: \(error)")
					} else {
						print("Document successfully written!")
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
	})
}


// MARK :- Utility Methods
func getOpenWeatherMapApiForCurrentLocationEndpoint(latitude lat: String, longitude lon: String) -> String {
	return "\(URLs.OPEN_WEATHER_BASE_API)weather?lat=\(lat)&lon=\(lon)&APPID=\(Constants.OPEN_WEATHER_MAP_API_KEY)&units=metric"
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
