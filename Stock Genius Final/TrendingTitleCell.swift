//
//  TrendingTitleCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TrendingTitleCell: UICollectionViewCell {

    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var trendingLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        trendingLabel.textColor = SGConstants.fontColorWhiteSecondary
        background.layer.cornerRadius = 5
        background.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        background.layer.borderColor = SGConstants.fontColorWhiteSecondary.cgColor
        background.layer.borderWidth = 1
    
    }

}
