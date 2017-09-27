//
//  WatchListPortfolio.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class WatchListPortfolio: NSObject {
    
    var name = "watchlist"
    var lastUpdated : Date?
    var holdings : [CurrentStock] = []
    
    init(name: name, lastUpdated: Date?, holdings : [CurrentStock]) {
        self.name = name
        self.lastUpdated = lastUpdated
        self.holdings = holdings
    }
    
    convenience init(fromCoreData portfolio: SGPortfolio) {
        
        let name = portfolio.name
        let lastUpdated : Date? = portfolio.lastPriceUpdate as? Date
        var holdings : [CurrentStock] = []
        
        for stock in portfolio.holdings {
            let currentStock = CurrentStock()
            currentStock.updateValuesFromCoreDataStock(stock)
            holdings.append(currentStock)
        }
        holdings.sort(by: {$0.rank < $1.rank})
        
        self.init(name: name, lastUpdated: lastUpdated, holdings: holdings)
    }
    
    public func saveToCoreData() {
        
        
    }

}
