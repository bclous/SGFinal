//
//  NextTwentyCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/6/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class NextTwentyCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = SGConstants.mainBlackColor
        mainLabel.textColor = SGConstants.fontColorWhiteSecondary
        mainLabel.text = "The following positions did not make the Stock Genius portfolio, but were also widely held by the managers we follow:"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
