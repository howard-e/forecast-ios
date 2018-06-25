//
//  OnboardingViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/23/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

	@IBOutlet weak var continueButton: UIButton!
	
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
		forecastLocationManger.startUpdatingLocation(controller: self, completionAction: {
			getWeatherInfo(controller: self, successSegue: SegueIdentifiers.toDashboard)
		})
	}
}
