//
//  CalculatorTableViewCell.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/19/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CalculatorTableViewCell: UITableViewCell {

    @IBOutlet weak var dollarPriceLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var totalInvestedLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCell() {
        borderView.backgroundColor = SGConstants.mainBlueColor
        dollarPriceLabel.textColor = UIColor.white
        tickerLabel.textColor = UIColor.white
        numberOfSharesLabel.textColor = UIColor.white
        totalInvestedLabel.textColor = UIColor.white
        borderView.alpha = 0.2
    }

}
