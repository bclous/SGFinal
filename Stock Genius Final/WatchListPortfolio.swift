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
    
    init(name: String, lastUpdated: Date, holdings : [CurrentStock]) {
        self.name = name
        self.lastUpdated = lastUpdated
        self.holdings = holdings
    }
    
    convenience init(fromCoreData portfolio: SGPortfolio) {
        
        var lastUpdated : Date = Date()
        let date = portfolio.lastPriceUpdate as Date?
        if date != nil {
            lastUpdated = date!
        }
        let name = portfolio.name ?? ""
        var holdings : [CurrentStock] = []
        let coreDataHoldings : [SGStock] = portfolio.holdings?.allObjects as? [SGStock] ?? []
        
        for stock in coreDataHoldings {
            let currentStock = CurrentStock()
            currentStock.updateValuesFromCoreDataStock(stock)
            holdings.append(currentStock)
        }
        holdings.sort(by: {$0.rankInPortfolio < $1.rankInPortfolio})
        
        self.init(name: name, lastUpdated: lastUpdated, holdings: holdings)
    }
    
    public func updatePrices(completion: @escaping (_ success: Bool) -> ()) {
        DataStore.shared.updatePricesForStocks(holdings) { (success) in
            if success {
                self.saveToCoreData()
            }
            completion(success)
        }
    }
    
    func addStockToWatchListFromSymbolResult(_ result: SymbolResult) -> Bool {
        let stock = CurrentStock()
        stock.updateValuesFromSymbolResult(result)
        return addStockToWatchList(stock)
    }
    
    public func saveToCoreData() {
        CDClient.saveWatchlistPortfolio(self)
    }
    
    public func addStockToWatchList(_ stock: CurrentStock) -> Bool {
        let contains = holdings.contains(stock)   // this isn't workign it's not the same object have to just check the ticker, also only show tickers we don't have
        if contains {
            return false
        } else {
            holdings.append(stock)
            saveToCoreData()
            return true
        }
    }
    
    public func removeStockFromWatchList(_ stock: CurrentStock) -> Bool {
        
        let indexOfStock = holdings.index(of: stock)
        
        if let index = indexOfStock {
            holdings.remove(at: index)
            saveToCoreData()
            return true
        } else {
            return false
        }
        
        
    }
    
}
