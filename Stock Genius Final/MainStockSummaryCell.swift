//
//  MainStockSummaryCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class MainStockSummaryCell: UITableViewCell {

    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var percentageChangeContainerView: UIView!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithPortfolio(_ portfolio: CurrentPortfolio, summaryType: SummaryType, isTodayReturn: Bool) {
        
        switch summaryType {
        case .average:
            mainLabel.text = "Average Return"
            percentageChangeLabel.text = portfolio.averageReturnString(isTodayReturn: isTodayReturn)
            directionLabel.text = portfolio.averageReturn(isTodayReturn: isTodayReturn) >= 0 ? "+" : "-"
            percentageChangeContainerView.backgroundColor = portfolio.averageReturn(isTodayReturn: isTodayReturn) >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        case .index:
            mainLabel.text = "S&P 500 Return"
            let startPrice = isTodayReturn ? portfolio.index.adjPriceLastClose : portfolio.index.adjPriceStartDate
            percentageChangeLabel.text = portfolio.index.percentageString(startPx: startPrice, endPx: portfolio.index.adjPriceCurrent)
            directionLabel.text = portfolio.index.adjPriceCurrent >= startPrice ? "+" : "-"
            percentageChangeContainerView.backgroundColor = portfolio.index.adjPriceCurrent >= startPrice ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        case .plusMinus:
            mainLabel.text = "Stock Genius +/-"
            percentageChangeLabel.text = portfolio.stockGeniusPlusMinusString(isTodayReturn: isTodayReturn)
            directionLabel.text = portfolio.stockGeniusPlusMinus(isTodayReturn: isTodayReturn) >= 0 ? "+" : "-"
            percentageChangeContainerView.backgroundColor = portfolio.stockGeniusPlusMinus(isTodayReturn: isTodayReturn) >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            
        }
        
    }

}
