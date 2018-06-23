//
//  ActivityIndicator.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class ActivityIndicator: UIViewController/*, NVActivityIndicatorViewable*/ {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func showActivityIndicator() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		//NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
		//startAnimating()
	}
	
	func hideActivityIndicator() {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			//stopAnimating()
		}
	}
}
