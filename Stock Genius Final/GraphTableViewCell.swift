//
//  GraphTableViewCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import SwiftChart

class GraphTableViewCell: UITableViewCell {

    @IBOutlet weak var performanceView: BDCStockPerformanceView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = SGConstants.mainBlackColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func formatChartCell(stock: CurrentStock) {
        performanceView.stocks = (stock: stock, index: DataStore.shared.currentPortfolio.index)
        performanceView.formatView()

    }
    
}
