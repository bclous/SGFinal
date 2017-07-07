//
//  PastPicksNoteCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/7/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPicksNoteCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        noteLabel.textColor = SGConstants.fontColorWhiteSecondary
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
