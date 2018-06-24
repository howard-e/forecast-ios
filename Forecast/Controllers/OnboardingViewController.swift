//
//  OnboardingViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/23/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingViewController: UIViewController {

	@IBOutlet weak var continueButton: UIButton!
	
	var weatherInfoRequested = false
	var canRequestWeatherInfo = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setUp()
    }
	
	func setUp() {
		// Set up button view
		continueButton.roundEdges()
		continueButton.layer.borderColor = Colors.textOrange.cgColor
		continueButton.layer.borderWidth = 1.0
	}
	
	@IBAction func requestLocationPermission(_ sender: Any) {
		weatherInfoRequested = false
		canRequestWeatherInfo = true
		
		forecastLocationMangaer.delegate = self
		forecastLocationMangaer.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .restricted:
				self.alert(message: "Unable to access Location. \"Forecast\" is not authorized to do so.", title: "Restricted")
				break
			case .denied:
				self.alert(message: "Please allow access if you want to use this feature.\nGo to 'Settings -> Privacy -> Location Services -> \"Forecast\" -> Allow Location Access for \"Forecast\".", title: "Access Denied", otherActionTitle: "Go To Settings") { _ in
					guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
						self.alert(message: "Unable to open App's Settings", title: "Error")
						return
					}
					
					if UIApplication.shared.canOpenURL(settingsUrl) {
						UIApplication.shared.open(settingsUrl, completionHandler: { success in
							print("Settings opened: \(success)")
						})
					}
				}
				break
			default:
				forecastLocationMangaer.startUpdatingLocation()
				break
			}
		} else {
			self.alert(message: "", title: "Turn On Location Services to Allow \"Forecast\" to Determine Your Location")
		}
	}
}

extension OnboardingViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .restricted:
			self.alert(message: "Unable to access Location. \"Forecast\" is not authorized to do so.", title: "Restricted")
			break
		case .denied:
			self.alert(message: "Please allow access if you want to use this feature.\nGo to 'Settings -> Privacy -> Location Services -> \"Forecast\" -> Allow Location Access for \"Forecast\".", title: "Access Denied", otherActionTitle: "Go To Settings") { _ in
				guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
					self.alert(message: "Unable to open App's Settings", title: "Error")
					return
				}
				
				if UIApplication.shared.canOpenURL(settingsUrl) {
					UIApplication.shared.open(settingsUrl, completionHandler: { success in
						print("Settings opened: \(success)")
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
			forecastLocationMangaer.stopUpdatingLocation()
			
			weatherInfoRequested = true
			if canRequestWeatherInfo && weatherInfoRequested {
				canRequestWeatherInfo = false
				print("Current Location: \(currentLocation)")
				
				let params: [String: Any] = [
					"lat": String(currentLocation.coordinate.latitude),
					"lon": String(currentLocation.coordinate.longitude)
				]
				
				let deviceId = getUserDefaults(string: UserDefaultsKeys.deviceId) ?? ""
				firestoreDb?.collection(deviceId).document("coordinates").setData(params) { error in
					if let error = error {
						print("Error writing document: \(error)")
					} else {
						print("Document successfully written!")
					}
				}
				
				getWeatherInfo(controller: self, params: params, successSegue: SegueIdentifiers.toDashboard)
			}
		}
	}
}
