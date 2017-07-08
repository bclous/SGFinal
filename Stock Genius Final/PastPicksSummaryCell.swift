//
//  PastPicksSummaryCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum SummaryType {
    case average
    case index
    case plusMinus
}

class PastPicksSummaryCell: UITableViewCell {

    
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var percentageChangeContainerView: UIView!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentageChangeContainerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithPortfolio(_ portfolio: PastPortfolio, summaryType: SummaryType) {
        
        switch summaryType {
        case .average:
            mainLabel.text = "Average Return"
            percentageChangeLabel.text = portfolio.averageReturnString()
            directionLabel.text = portfolio.averageReturn() >= 0 ? "+" : "-"
            percentageChangeContainerView.backgroundColor = portfolio.averageReturn() >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        case .index:
            mainLabel.text = "S&P 500 Return"
            percentageChangeLabel.text = portfolio.index.percentageChangeString()
            directionLabel.text = portfolio.index.finalPercentageReturn >= 0 ? "+" : "-"
            percentageChangeContainerView.backgroundColor = portfolio.index.finalPercentageReturn >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        case .plusMinus:
            mainLabel.text = "Stock Genius +/-"
            percentageChangeLabel.text = portfolio.stockGeniusPlusMinusString()
            directionLabel.text = portfolio.stockGeniusPlusMinus() >= 0 ? "+" : "-"
            percentageChangeContainerView.backgroundColor = portfolio.stockGeniusPlusMinus() >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor

        }
    }
    
}
