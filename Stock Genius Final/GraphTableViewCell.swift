//
//  GraphTableViewCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Charts

class GraphTableViewCell: UITableViewCell {

    @IBOutlet weak var lineChart: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
