//
//  MainStockCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class MainStockCell: UITableViewCell {


    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var dollarPriceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceDirectionImageView: UIImageView!
    @IBOutlet weak var percentageChangeContainerView: UIView!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var percentageChangeDirectionLabel: UILabel!
    @IBOutlet weak var notTradingView: UIView!
    @IBOutlet weak var notTradingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentageChangeContainerView.layer.cornerRadius = 10
        //percentageChangeLabel.text = "1.9%"
        dollarPriceLabel.text = "114.54"
        companyNameLabel.text = "Apple Inc."
        contentView.backgroundColor = SGConstants.mainBlackColor
        customBackgroundView.alpha = 0.1
        notTradingLabel.text = "Acquired\nsee notes"
        notTradingView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithStock(_ stock: CurrentStock, isOneDayReturn: Bool) {
        
        if stock.ticker == "BSX" {
            
        }
        
        let startPeriodPrice = stock.isTrading ? stock.adjPriceStartDate : stock.startingPriceHardCode
        let startingPx = isOneDayReturn ? stock.adjPriceLastClose : startPeriodPrice
        let isPositive = stock.isTrading ? stock.adjPriceCurrent >= startingPx : stock.acquiredPrice >= startingPx
        tickerLabel.text = stock.ticker
        companyNameLabel.text = stock.companyName
        dollarPriceLabel.text = stock.isTrading ? stock.priceString(stock.adjPriceCurrent) : stock.priceString(stock.acquiredPrice)
        priceDirectionImageView.image = stock.isTrading ? stock.dollarChangeImage(startPx: startingPx, endPx: stock.adjPriceCurrent) : stock.dollarChangeImage(startPx: startingPx, endPx: stock.acquiredPrice)
        percentageChangeContainerView.layer.cornerRadius = 10
        
        
        if isOneDayReturn {
            priceChangeLabel.text = stock.isTrading ? stock.priceString(abs(stock.adjPriceCurrent - startingPx)) : "-"
            priceDirectionImageView.alpha = stock.isTrading ? 1 : 0
            let color = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            let changeString = isPositive ? "+" : "-"
            percentageChangeContainerView.backgroundColor = stock.isTrading ? color : SGConstants.mainBlackColor
            percentageChangeDirectionLabel.text = stock.isTrading ? changeString : ""
            percentageChangeLabel.text = stock.isTrading ? stock.percentageString(startPx: startingPx, endPx: stock.adjPriceCurrent) : ""
            notTradingView.alpha = stock.isTrading ? 0 : 1
        } else {
            priceDirectionImageView.alpha = 1
            priceChangeLabel.text = stock.isTrading ? stock.priceString(abs(stock.adjPriceCurrent - startingPx)) : stock.priceString(abs(stock.acquiredPrice - startingPx))
            percentageChangeContainerView.backgroundColor = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            percentageChangeLabel.text = stock.isTrading ? stock.percentageString(startPx: startingPx, endPx: stock.adjPriceCurrent) : stock.percentageString(startPx: startingPx, endPx: stock.acquiredPrice)
            percentageChangeDirectionLabel.text = isPositive ? "+" : "-"
            notTradingView.alpha = 0
        }
    }

}
