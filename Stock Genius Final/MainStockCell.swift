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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentageChangeContainerView.layer.cornerRadius = 10
        //percentageChangeLabel.text = "1.9%"
        dollarPriceLabel.text = "114.54"
        companyNameLabel.text = "Apple Inc."
        contentView.backgroundColor = SGConstants.mainBlackColor
        customBackgroundView.alpha = 0.03
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithStock(_ stock: CurrentStock, isOneDayReturn: Bool) {
        
        let startingPx = isOneDayReturn ? stock.adjPriceLastClose : stock.adjPriceStartDate
        let isPositive = stock.adjPriceCurrent >= startingPx
        tickerLabel.text = stock.ticker
        companyNameLabel.text = stock.companyName
        dollarPriceLabel.text = stock.priceString(stock.adjPriceCurrent)
        priceChangeLabel.text = stock.priceString(stock.adjPriceCurrent - startingPx)
        priceDirectionImageView.image = stock.dollarChangeImage(startPx: startingPx, endPx: stock.adjPriceCurrent)
        percentageChangeContainerView.layer.cornerRadius = 10
        percentageChangeContainerView.backgroundColor = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        percentageChangeLabel.text = stock.percentageString(startPx: startingPx, endPx: stock.adjPriceCurrent)
        percentageChangeDirectionLabel.text = isPositive ? "+" : "-"

    
    }

}
