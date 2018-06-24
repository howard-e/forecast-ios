//
//  HttpManager.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import Foundation
import Alamofire

// Encapsulates the logic for sending various HTTP Requests
class HttpManager {
	
	static var shared = HttpManager()
	
	init() {
	}
	
	func get(url: String, completion: @escaping (DataResponse<Any>) -> ()) {
		let sessionManager = Alamofire.SessionManager.default
		sessionManager.session.configuration.timeoutIntervalForRequest = Constants.SERVER_TIMEOUT
		sessionManager.request(url, method: .get).responseJSON(completionHandler: completion)
	}
}
