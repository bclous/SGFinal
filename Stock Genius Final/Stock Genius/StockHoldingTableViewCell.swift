//
//  StockHoldingTableViewCell.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/18/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class StockHoldingTableViewCell: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var isTodayReturn = true
    var stock : Holding?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCell() {
        
        if let stockHolding = stock {
            tickerLabel.text = stockHolding.ticker!
            nameLabel.text = stockHolding.name!
            let price = String(format: "%.2f",stockHolding.adjPxCurrent)
            let todayPriceChangeString = stockHolding.adjPxCurrent - stockHolding.adjPxTminus1Day < 0 ? String(format:"%.2f", stockHolding.adjPxCurrent - stockHolding.adjPxTminus1Day) : String(format:"+%.2f", stockHolding.adjPxCurrent - stockHolding.adjPxTminus1Day)
                
            let sinceDatePriceChangeString = stockHolding.adjPxCurrent - stockHolding.adjPxStartDate < 0 ? String(format:"%.2f", stockHolding.adjPxCurrent - stockHolding.adjPxStartDate) : String(format:"+%.2f", stockHolding.adjPxCurrent - stockHolding.adjPxStartDate)
            
            let todayPercentageReturn = 100 * ((stockHolding.adjPxCurrent / stockHolding.adjPxTminus1Day) - 1)
            let sinceDatePercentageReturn = 100 * ((stockHolding.adjPxCurrent / stockHolding.adjPxStartDate) - 1)
            
            let todayPercentageReturnString = todayPercentageReturn < 0 ? String(format:"%.2f",todayPercentageReturn) : String(format:"+%.2f",todayPercentageReturn)
            let sinceDatePercentageReturnString = sinceDatePercentageReturn < 0 ? String(format:"%.2f",sinceDatePercentageReturn) : String(format:"+%.2f",sinceDatePercentageReturn)
            
            let todayFullChangeString = "\(todayPriceChangeString)   \(todayPercentageReturnString)%"
            let sinceDateFullChangeString = "\(sinceDatePriceChangeString)    \(sinceDatePercentageReturnString)%"
            
            priceLabel.text = price
            containerView.layer.cornerRadius = 0
            
            let stockReturn = isTodayReturn ? (stockHolding.adjPxCurrent / stockHolding.adjPxTminus1Day) : (stockHolding.adjPxCurrent / stockHolding.adjPxStartDate)
            
            priceChangeLabel.text = isTodayReturn ? todayFullChangeString : sinceDateFullChangeString
            
            let isPositive = isTodayReturn ? todayPercentageReturn >= 0 : sinceDatePercentageReturn >= 0
            
            priceChangeLabel.textColor = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            backgroundColor = SGConstants.offBlackColor
            
        }
        
    }

}
