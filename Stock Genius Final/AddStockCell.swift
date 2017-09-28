//
//  AddStockCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/28/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class AddStockCell: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    var symbolResult : SymbolResult?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func formatCellWithSymbolResult(_ result: SymbolResult) {
        symbolResult = result
        tickerLabel.text = result.ticker
        companyNameLabel.text = result.name
    }
    
}
