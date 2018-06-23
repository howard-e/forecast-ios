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


// MARK :- API Methods
func getWeatherInfo(controller: UIViewController, params: [String: Any]) {
	let resourceUrl = getOpenWeatherMapApiForCurrentLocationEndpoint(latitude: params["lat"] as? String ?? "", longitude: params["lon"] as? String ?? "")
	logRequestInfo(#function, resourceUrl, requestParams: params)
	
	showActivityIndicator(true)
	httpManager.get(url: resourceUrl, completion: { (response: DataResponse<Any>) -> () in
		if let responseData = response.result.value {
			debugPrint(responseData)
			
			let lastRefreshed = JSON(responseData)["dt"].intValue
			let temperatureInfo = JSON(responseData)["main"]
			let temperature = temperatureInfo["temp"].stringValue
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
func getOpenWeatherMapApiForCurrentLocationEndpoint(latitude lat: String, longitude long: String) -> String {
	return "\(URLs.OPEN_WEATHER_BASE_API)weather?lat=\(lat)&lon=\(long)&APPID=\(Constants.OPEN_WEATHER_MAP_API_KEY)&units=metric"
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
