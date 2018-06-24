//
//  ForecastTableViewCell.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

	@IBOutlet weak var weatherConditionIndicatorImageView: UIImageView!
	@IBOutlet weak var weatherConditionLabel: UILabel!
	@IBOutlet weak var forecastTimeLabel: UILabel!
	@IBOutlet weak var weatherConditionTemperatureLabel: UILabel!
	@IBOutlet weak var bottomDividerImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
