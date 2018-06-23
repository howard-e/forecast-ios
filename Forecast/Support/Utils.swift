//
//  Utils.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import Foundation

let activityIndicator = ActivityIndicator()

func showActivityIndicator(_ show: Bool) {
	show ? activityIndicator.showActivityIndicator() : activityIndicator.hideActivityIndicator()
}

func setUserDefaults(string value: String, key: String) {
	UserDefaults.standard.set(value, forKey: key)
}

func setUserDefaults(int value: Int, key: String) {
	UserDefaults.standard.set(value, forKey: key)
}

func setUserDefaults(Double value: Double, key: String) {
	UserDefaults.standard.set(value, forKey: key)
}

func setUserDefaults(any value: Any, key: String) {
	UserDefaults.standard.set(value, forKey: key)
}

func setUserDefaults(bool value: Bool, key: String) {
	UserDefaults.standard.set(value, forKey: key)
}

func getUserDefaults(string key: String) -> String? {
	return UserDefaults.standard.string(forKey: key)
}

func getUserDefaults(int key: String) -> Int? {
	return UserDefaults.standard.integer(forKey: key)
}

func getUserDefaults(Double key: String) -> Double? {
	return UserDefaults.standard.double(forKey: key)
}

func getUserDefaults(bool key: String) -> Bool {
	return UserDefaults.standard.bool(forKey: key)
}

func getUserDefaults(any key: String) -> Any? {
	return UserDefaults.standard.object(forKey: key)
}

func removeFromUserDefaults(key: String) {
	UserDefaults.standard.removeObject(forKey: key)
}

