//
//  TodayViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
	
	@IBOutlet weak var weatherStatusIndicatorImageView: UIImageView!
	@IBOutlet weak var temperatureWeatherConditionLabel: UILabel!
	
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var precipitationLabel: UILabel!
	@IBOutlet weak var pressureLabel: UILabel!
	@IBOutlet weak var windSpeedLabel: UILabel!
	@IBOutlet weak var windDirectionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUp()
	}

	func setUp() {
		// Views Set Up
	}
	
	@IBAction func setCurrentLocation(_ sender: Any) {
	}
	
	@IBAction func shareWeatherInfo(_ sender: Any) {
	}
}

