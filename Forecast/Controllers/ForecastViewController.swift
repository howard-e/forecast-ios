//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var forecastTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUp()
    }
	
	func setUp() {
		// TODO: Display user's current location
		
		// Set up tableview
		let nib = UINib(nibName: XibCells.forecastCell, bundle: nil)
		forecastTableView.register(nib, forCellReuseIdentifier: CellIdentifiers.forecastCell)
		forecastTableView.delegate = self
		forecastTableView.dataSource = self
		forecastTableView.rowHeight = 150
		forecastTableView.estimatedRowHeight = 150
	}
}


// MARK :- UITableViewDataSource Methods
extension ForecastViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}
	
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		switch section {
//		case 1:
//			return "Today"
//		case 2:
//			return "Tomorrow"
//		default:
//			return "Future"
//		}
//	}
	
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		// Create Header View Container
//		let headerView = UIView()
//		headerView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
//
//		// Create Top Divider View
//		let topDivider = UIImageView()
//		topDivider.image = UIImage(named: "Divider1px")
//		headerView.addSubview(topDivider)
//
//		NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: topDivider, attribute: .trailing, multiplier: 1, constant: 0).isActive = true // Tralinig Constraint to Super
//		NSLayoutConstraint(item: topDivider, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true // Leading Constraint to Super
//		NSLayoutConstraint(item: topDivider, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1, constant: 0).isActive = true // Top Constraint to Super
//
//
//		// Create Header Text Label
//		let headerTextLabel = UILabel()
//		headerTextLabel.font = UIFont(name: "ProximaNova-Light", size: 18.0)
//		headerTextLabel.textColor = .black
//		headerView.addSubview(headerTextLabel)
//
//		switch section {
//		case 0:
//			headerTextLabel.text = "Today"
//		case 1:
//			headerTextLabel.text = "Tomorrow"
//		default:
//			headerTextLabel.text = "Future"
//		}
//
//		NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: headerTextLabel, attribute: .trailing, multiplier: 1, constant: 16).isActive = true // Tralinig Constraint to Super
//		NSLayoutConstraint(item: headerTextLabel, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 16).isActive = true // Leading Constraint to Super
//		NSLayoutConstraint(item: headerTextLabel, attribute: .top, relatedBy: .equal, toItem: topDivider, attribute: .bottom, multiplier: 1, constant: 0).isActive = true // Top Constraint to Divider
//
//
//		// Create Bottom Divider View
//		let bottomDivider = UIImageView()
//		bottomDivider.image = UIImage(named: "Divider1px")
//		headerView.addSubview(bottomDivider)
//
//		NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: bottomDivider, attribute: .trailing, multiplier: 1, constant: 0).isActive = true // Tralinig Constraint to Super
//		NSLayoutConstraint(item: bottomDivider, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true // Leading Constraint to Super
//		NSLayoutConstraint(item: headerView, attribute: .bottom, relatedBy: .equal, toItem: bottomDivider, attribute: .bottom, multiplier: 1, constant: 0).isActive = true // Bottom Constraint to Super
//		NSLayoutConstraint(item: bottomDivider, attribute: .top, relatedBy: .equal, toItem: headerTextLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true // Top Constraint to Label
//
//		return headerView
//	}
	
//	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		return 50
//	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.forecastCell, for: indexPath) as! ForecastTableViewCell
		
		return cell
	}
}


// MARK :- UITableViewDataDelegate Methods
extension ForecastViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
