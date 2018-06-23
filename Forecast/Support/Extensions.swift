//
//  Extensions.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

extension UIViewController {
	// Show simple alert dialog with a title, description and an OK button
	func alert(message: String, title: String? = nil, okActionTitle: String? = "OK", customHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: customHandler)
		alertController.addAction(okAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
}
