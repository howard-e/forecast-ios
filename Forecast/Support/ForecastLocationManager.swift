//
//  ForecastLocationManager.swift
//  Forecast
//
//  Created by Howard Edwards on 6/24/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastLocationManager: NSObject {
	
	let locationManager = CLLocationManager()
	
	var controller: UIViewController!
	var completionAction: (() -> Void)? = nil
	
	var weatherInfoRequested = false
	var canRequestWeatherInfo = true
	
	static var shared = ForecastLocationManager()
	
	func startUpdatingLocation(controller: UIViewController, completionAction: (() -> Void)? = nil) {
		weatherInfoRequested = false
		canRequestWeatherInfo = true
		
		self.controller = controller
		self.completionAction = completionAction
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .restricted:
				controller.alert(message: "Unable to access Location. \"Forecast\" is not authorized to do so.", title: "Restricted")
				break
			case .denied:
				controller.alert(message: "Please allow access if you want to use this feature.\nGo to 'Settings -> Privacy -> Location Services -> \"Forecast\" -> Allow Location Access for \"Forecast\".", title: "Access Denied", otherActionTitle: "Go To Settings") { _ in
					guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
						controller.alert(message: "Unable to open App's Settings", title: "Error")
						return
					}
					
					if UIApplication.shared.canOpenURL(settingsUrl) {
						UIApplication.shared.open(settingsUrl, completionHandler: { success in
							// Perform action
						})
					}
				}
				break
			default:
				locationManager.startUpdatingLocation()
				break
			}
		} else {
			controller.alert(message: "", title: "Turn On Location Services to Allow \"Forecast\" to Determine Your Location")
		}
	}
	
	func stopUpdatingLocation() {
		locationManager.stopUpdatingLocation()
	}
}


// MARK: CLLocationManagerDelgate Methods
extension ForecastLocationManager: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .restricted:
			controller.alert(message: "Unable to access Location. \"Forecast\" is not authorized to do so.", title: "Restricted")
			break
		case .denied:
			controller.alert(message: "Please allow access if you want to use this feature.\nGo to 'Settings -> Privacy -> Location Services -> \"Forecast\" -> Allow Location Access for \"Forecast\".", title: "Access Denied", otherActionTitle: "Go To Settings") { _ in
				guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
					self.controller.alert(message: "Unable to open App's Settings", title: "Error")
					return
				}
				
				if UIApplication.shared.canOpenURL(settingsUrl) {
					UIApplication.shared.open(settingsUrl, completionHandler: { success in
						// Perform action
					})
				}
			}
			break
		default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		// Get user coordinates; check OpenWeatherApi route; go to dashboard
		if locations.count > 0, let currentLocation = locations.last {
			locationManager.stopUpdatingLocation()
			
			weatherInfoRequested = true
			if canRequestWeatherInfo && weatherInfoRequested {
				canRequestWeatherInfo = false
				
				let params: [String: Any] = [
					"lat": String(currentLocation.coordinate.latitude),
					"lon": String(currentLocation.coordinate.longitude)
				]
				setUserDefaults(any: params, key: UserDefaultsKeys.lastestCoordinates)
				
				let deviceId = getUserDefaults(string: UserDefaultsKeys.deviceId) ?? ""
				firestoreDb?.collection(deviceId).document("coordinates").setData(params) { error in
					if error != nil { // Handle error
					} else { // Successfully written
					}
				}
				
				if let completionAction = self.completionAction {
					completionAction()
				}
			}
		}
	}
}
