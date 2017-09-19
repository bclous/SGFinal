//
//  PastHoldingTableViewCell.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/23/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastHoldingTableViewCell: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    
    var holding : Holding?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCell() {
        if let stock = holding {
            tickerLabel.text = stock.ticker
            let priceChange = stock.finalAdjEndPx - stock.finalAdjStartPx
            let percentageChange = 100 * ((stock.finalAdjEndPx / stock.finalAdjStartPx) - 1)
            priceChangeLabel.text = priceChange >= 0 ? String(format:"+%.2f",priceChange) : String(format:"%.2f",priceChange)
            percentageChangeLabel.text = percentageChange >= 0 ? String(format:"+%.2f",percentageChange) + "%" : String(format:"%.2f",percentageChange) + "%"
            //priceChangeLabel.textColor = priceChange >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            //percentageChangeLabel.textColor = percentageChange >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            contentView.backgroundColor = SGConstants.offBlackColor
        }
    }

}
