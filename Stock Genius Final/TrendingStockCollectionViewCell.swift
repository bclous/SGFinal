//
//  TrendingStockCollectionViewCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TrendingStockCollectionViewCell: UICollectionViewCell {
    
    let stockView = TrendingStockIndividualView()
    
    public func formatCellWithStock(_ stock: CurrentStock) {
        contentView.addSubview(stockView)
        stockView.translatesAutoresizingMaskIntoConstraints = false
        stockView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stockView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stockView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        stockView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        stockView.formatViewWithStock(stock)
    }
    
}
