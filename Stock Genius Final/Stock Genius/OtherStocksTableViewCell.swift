//
//  OtherStocksTableViewCell.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/18/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class OtherStocksTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCell() {
        contentView.backgroundColor = SGConstants.offBlackColor
    }

}
