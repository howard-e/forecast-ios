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
	
	func get(url: String, additionalHeaders: Dictionary<String, String>? = nil, completion: @escaping (DataResponse<Any>) -> ()) {
		var headers: HTTPHeaders = [:]
		
		if let additionalHeaders = additionalHeaders {
			for (key, value) in additionalHeaders {
				headers[key] = value
			}
		}
		
		let sessionManager = Alamofire.SessionManager.default
		sessionManager.session.configuration.timeoutIntervalForRequest = Constants.SERVER_TIMEOUT
		sessionManager.request(url, method: .get, headers: headers).responseJSON(completionHandler: completion)
	}
	
	func post(url: String!, parameters: Dictionary<String, Any>, additionalHeaders: Dictionary<String, String>? = nil, completion: @escaping (DataResponse<Any>) -> ()) {
		var headers = ["Content-Type": "application/json"]
		
		if let additionalHeaders = additionalHeaders {
			for (key, value) in additionalHeaders {
				headers[key] = value
			}
		}
		
		let sessionManager = Alamofire.SessionManager.default
		sessionManager.session.configuration.timeoutIntervalForRequest = Constants.SERVER_TIMEOUT
		sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: completion)
	}
	
	func postXml(url: String!, parameters: Dictionary<String, Any>, additionalHeaders: Dictionary<String, String>? = nil, completion: @escaping (DataResponse<String>) -> ()) {
		var headers = ["Content-Type": "application/x-www-form-urlencoded"]
		
		if let additionalHeaders = additionalHeaders {
			for (key, value) in additionalHeaders {
				headers[key] = value
			}
		}
		
		let sessionManager = Alamofire.SessionManager.default
		sessionManager.session.configuration.timeoutIntervalForRequest = Constants.SERVER_TIMEOUT
		sessionManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding(), headers: headers).responseString(completionHandler: completion)
	}
	
	func put(url: String!, parameters: Dictionary<String, Any>? = nil, additionalHeaders: Dictionary<String, String>? = nil, completion: @escaping (DataResponse<Any>) -> ()) {
		var headers = ["Content-Type": "application/json"]
		
		
		if let additionalHeaders = additionalHeaders {
			for (key, value) in additionalHeaders {
				headers[key] = value
			}
		}
		
		let sessionManager = Alamofire.SessionManager.default
		sessionManager.session.configuration.timeoutIntervalForRequest = Constants.SERVER_TIMEOUT
		sessionManager.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: completion)
	}
	
	func delete(url: String!, parameters: Dictionary<String, Any>? = nil, additionalHeaders: Dictionary<String, String>? = nil, completion: @escaping (DataResponse<Any>) -> ()) {
		var headers: HTTPHeaders = [:]
		
		if let additionalHeaders = additionalHeaders {
			for (key, value) in additionalHeaders {
				headers[key] = value
			}
		}
		
		let sessionManager = Alamofire.SessionManager.default
		sessionManager.session.configuration.timeoutIntervalForRequest = Constants.SERVER_TIMEOUT
		sessionManager.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: completion)
	}
}
