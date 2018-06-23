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
