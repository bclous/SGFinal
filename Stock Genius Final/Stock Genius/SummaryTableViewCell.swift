//
//  SummaryTableViewCell.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/18/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    var portfolio : Portfolio?
    var isCurrent = false
    var isToday = false
    var isMainHoldingsPage = true

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var plusMinusLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func formatCell() {
        
        contentView.backgroundColor = SGConstants.offBlackColor
        
        var averageReturn : Float = 0
        var indexReturn : Float = 0
        var plusMinus : Float = 0
        
        if let port = portfolio {
            averageReturn = isCurrent ? CDClient.averageReturnFromCurrentPortfolio(port, todayReturn: isToday) : CDClient.averageReturnFromPastPortfolio(port)
            indexReturn = isCurrent ? CDClient.indexReturnFromCurrentPortfolio(port, todayReturn: isToday) : CDClient.indexReturnFromPastPortfolio(port)
            plusMinus = averageReturn - indexReturn
        }
        
        averageLabel.text = SGConstants.percentageChangeStringFrom(averageReturn)
        indexLabel.text = SGConstants.percentageChangeStringFrom(indexReturn)
        plusMinusLabel.text = SGConstants.percentageChangeStringFrom(plusMinus)
        
        if isMainHoldingsPage {
            averageLabel.textColor = averageReturn >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            indexLabel.textColor = indexReturn >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            plusMinusLabel.textColor = plusMinus >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
            
        }
    
        
        
    }

}
