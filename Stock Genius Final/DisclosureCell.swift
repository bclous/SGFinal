//
//  DisclosureCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/10/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class DisclosureCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        mainLabel.textColor = SGConstants.fontColorWhiteSecondary
        mainLabel.text = "This calculator creates an evenly weighted portfolio of our ten stock picks, based on your total investment amount input.\n\nA 3% remaining cash buffer is incorporated into each calculation.\n\nThis calculator is provided for informational purchases and is not intended as recommendation to buy or sell stocks.  For more information please see our terms of service."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
