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

extension UIView {
	func roundEdges(radius: CGFloat = 2.0) {
		self.layer.masksToBounds = true
		self.layer.cornerRadius = radius
	}
}

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(hexString: String) {
		let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
		let scanner = Scanner(string: hexString)
		
		if (hexString.hasPrefix("#")) {
			scanner.scanLocation = 1
		}
		
		var color:UInt32 = 0
		scanner.scanHexInt32(&color)
		
		let mask = 0x000000FF
		let r = Int(color >> 16) & mask
		let g = Int(color >> 8) & mask
		let b = Int(color) & mask
		
		let red   = CGFloat(r) / 255.0
		let green = CGFloat(g) / 255.0
		let blue  = CGFloat(b) / 255.0
		
		self.init(red: red, green: green, blue: blue, alpha: 1)
	}
	
	func toHexString() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		getRed(&r, green: &g, blue: &b, alpha: &a)
		
		let rgb: Int = (Int)(r*255) << 16 | (Int)(g*255) << 8 | (Int)(b*255) << 0
		
		return String(format:"#%06x", rgb)
	}
}
