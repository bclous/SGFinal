//
//  PastPicksStockCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPicksStockCell: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var percentageChangeContainerView: UIView!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var percentageDirectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        percentageChangeContainerView.layer.cornerRadius = 5
        directionImageView.image = UIImage(named: "upImage")
        percentageChangeContainerView.backgroundColor = SGConstants.mainGreenColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func formatCellWithPastStock(_ stock: PastStock) {
        
        let isPositive = stock.adjPriceEndDate >= stock.adjPriceStartDate
        tickerLabel.text = stock.ticker
        companyNameLabel.text = stock.companyName
        directionImageView.image = stock.dollarChangeImage(startPx: stock.adjPriceStartDate, endPx: stock.adjPriceEndDate)
        priceChangeLabel.text = stock.priceString(stock.adjPriceEndDate - stock.adjPriceStartDate)
        percentageChangeContainerView.backgroundColor = isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        percentageChangeLabel.text = stock.percentageString(startPx: stock.adjPriceStartDate, endPx: stock.adjPriceEndDate)
        percentageDirectionLabel.text = isPositive ? "+" : "-"
        
    }

}
