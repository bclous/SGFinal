//
//  ShareCalcCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class ShareCalcCell: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var dollarPriceLabel: UILabel!
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    let numberFormatter = NumberFormatter()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithCalcStock(_ calcStock: CalculatorStock) {
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.minimumFractionDigits = 0
        let totalMoneyRounded : Float = round(calcStock.totalMoney * 100) / 100.0
        if let total = numberFormatter.string(from: NSNumber(value: totalMoneyRounded)) {
            totalMoneyLabel.text = "$ " + total
        }
        if let sharesString = numberFormatter.string(from: NSNumber(value: calcStock.shares)) {
            numberOfSharesLabel.text = sharesString
        }
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
       
        if let sharePrice = numberFormatter.string(from: NSNumber(value: calcStock.stock.adjPriceCurrent)) {
            dollarPriceLabel.text =  sharePrice
        }
        
        tickerLabel.text = calcStock.stock.ticker
        
    }

}
