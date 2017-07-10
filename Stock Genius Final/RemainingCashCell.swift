//
//  RemainingCashCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/10/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class RemainingCashCell: UITableViewCell {

    @IBOutlet weak var totalMoneyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithRemainingCash(_ cash: Float) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.minimumFractionDigits = 0
        if let total = numberFormatter.string(from: NSNumber(value: cash)) {
            totalMoneyLabel.text = "$ " + total
        }

    }

}
