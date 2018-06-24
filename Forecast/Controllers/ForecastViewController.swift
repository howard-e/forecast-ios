//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
import SwiftEventBus

class ForecastViewController: UIViewController {

	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var forecastTableView: UITableView!
	
	let refreshControl = UIRefreshControl()
	
	var sectionNames = [String]()
	var tableData = [String: [Forecast]]()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getLatestForecastData()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUp()
    }
	
	func setUp() {
		// Set up tableview
		let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont(name: "ProximaNova-Light", size: 14)!]
		refreshControl.attributedTitle = NSAttributedString(string: "Getting the latest 5-day forecast", attributes: attributes)
		refreshControl.addTarget(self, action: #selector(getLatestForecastData), for: UIControlEvents.valueChanged)
		forecastTableView.refreshControl = refreshControl
		
		forecastTableView.register(UINib(nibName: XibCells.forecastCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.forecastCell)
		forecastTableView.register(UINib(nibName: XibCells.customHeaderCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.customHeaderCell)
		
		forecastTableView.delegate = self
		forecastTableView.dataSource = self
		forecastTableView.rowHeight = 150
		forecastTableView.estimatedRowHeight = 150
		
		loadTableData()
		SwiftEventBus.onMainThread(self, name: EventBusParams.forecastWeatherInfo) { result in
			let success = result?.object as? Bool ?? false
			
			self.loadTableData(success)
			self.refreshControl.stopRefresh()
		}
	}
	
	func loadTableData(_ success: Bool = false) {
		if success {
			sectionNames.removeAll()
			tableData.removeAll()
			forecastTableView.reloadData()
		}
		
		// TODO: Pull from Firebase if unavailable
		let forecastInfo = getUserDefaults(any: UserDefaultsKeys.forecastInfo) as? [String: Any] ?? [:]
		let locationName = forecastInfo["location_name"] as? String ?? "Location N/A"
		locationLabel.text = locationName
		
		// Set up Table View Data
		let forecastObjects = forecastInfo["forecast_data"] as? [[String: Any]] ?? [[:]]
		for item in forecastObjects {
			let timestamp = item["timestamp"] as? Double ?? -1
			let temperature = item["temperature"] as? Double ?? -1
			let weatherIcon = item["weather_status_icon"] as? String ?? ""
			let weatherCondition = item["weather_condition"] as? String ?? ""
			
			let forecast = Forecast(timestamp: timestamp, temperature: temperature, weatherStatusIcon: weatherIcon, weatherCondition: weatherCondition)
			
			if !sectionNames.contains(forecast.weekday()) {
				sectionNames.append(forecast.weekday())
			}
			
			if tableData[forecast.weekday()] == nil {
				tableData[forecast.weekday()] = [Forecast]()
			}
			tableData[forecast.weekday()]?.append(forecast)
		}
		forecastTableView.reloadData()
	}
	
	@objc func getLatestForecastData() {
		forecastLocationManger.startUpdatingLocation(controller: self, completionAction: {
			getFiveDayForcecast(controller: self)
		})
	}
}


// MARK :- UITableViewDataSource Methods
extension ForecastViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionNames.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let  headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.customHeaderCell) as! CustomHeaderTableViewCell
		headerCell.headerTextLabel.text = sectionNames[section].uppercased()
		return headerCell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let dayForecastData = tableData[sectionNames[section]] {
			return dayForecastData.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.forecastCell, for: indexPath) as! ForecastTableViewCell
		let section = indexPath.section
		let row = indexPath.row
		
		if let dayForecastData = tableData[sectionNames[section]] {
			let forecast = dayForecastData[row]
			
			if row == dayForecastData.count - 1 {
				cell.bottomDividerImageView.isHidden = true
			} else {
				cell.bottomDividerImageView.isHidden = false
			}
			
			let condition = WeatherCondition.evaluateWeatherCondition(forecast.weatherStatusIcon)
			if let condition = condition, let time = forecast.weatherStatusIcon.last {
				switch time {
				case "d":
					cell.weatherConditionIndicatorImageView.image = Constants.WEATHER_CONDITION_IMAGE_DAY[condition]
				case "n":
					cell.weatherConditionIndicatorImageView.image = Constants.WEATHER_CONDITION_IMAGE_NIGHT[condition]
				default:
					break
				}
			}
			
			cell.forecastTimeLabel.text = forecast.getTimeOfDay()
			cell.weatherConditionLabel.text = forecast.weatherCondition
			cell.weatherConditionTemperatureLabel.text = "\(String(format: "%.0f", forecast.temperature))°C"
		}
		
		return cell
	}
}


// MARK :- UITableViewDataDelegate Methods
extension ForecastViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
