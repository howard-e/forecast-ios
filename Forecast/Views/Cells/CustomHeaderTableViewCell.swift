//
//  CustomHeaderTableViewCell.swift
//  Forecast
//
//  Created by Howard Edwards on 6/23/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit

class CustomHeaderTableViewCell: UITableViewCell {

	@IBOutlet weak var headerTextLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
