//
//  TrendingStocksCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TrendingStocksCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func formatCell() {
         let trendingView = TrendingStocksView()
        contentView.addSubview(trendingView)
        trendingView.translatesAutoresizingMaskIntoConstraints = false
        trendingView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        trendingView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        trendingView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        trendingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        trendingView.updateTrendingStocksView()
        
    }

}
