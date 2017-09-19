//
//  StockHoldingCell2.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class StockHoldingCell2: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentChangLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeImage: UIImageView!
    
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
    
    public func formatCell() {
        
        if let stockHolding = stock {
            
            let beginPrice = isTodayReturn ? stockHolding.adjPxTminus1Day : stockHolding.adjPxStartDate
            let endPrice = stockHolding.adjPxCurrent
            let isPositive = endPrice >= beginPrice
            let priceReturn = SGConstants.priceChangeStringNoSignFrom(beginPrice: beginPrice, endPrice: endPrice)
            let percentageReturn = SGConstants.percentageChangeStringFrom(beginPrice: beginPrice, endPrice: endPrice)
            let price = String(format: "%.2f",stockHolding.adjPxCurrent)
            
            priceLabel.text = price
            tickerLabel.text = stockHolding.ticker
            priceChangeLabel.text = priceReturn
            percentChangLabel.text = percentageReturn
            priceChangeImage.image = isPositive ? UIImage(named: "green triangle") : UIImage(named: "redTriangle")
            priceChangeLabel.textColor = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            percentChangLabel.textColor = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            backgroundColor = SGConstants.offBlackColor
            
            
            
        }
        
    }

}
