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
    var trendingStocks : [CurrentStock] = []
    
    init(name: String, lastUpdated: Date, holdings : [CurrentStock], trendingStocks : [CurrentStock]) {
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
        
        self.init(name: name, lastUpdated: lastUpdated, holdings: holdings, trendingStocks: [])
    }
    
    public func updateTrendingStocksFromResponse(_ response: [[String : Any]]) {
        
        trendingStocks.removeAll()
        for stockResponse in response {
            let stock = CurrentStock()
            stock.updateValesFromTrendingResult(stockResponse)
            trendingStocks.append(stock)
        }
        
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
        updateHoldingIndexRanks()
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
    
    public func switchStockOrderAtIndex(_ index: Int, withIndex index2: Int) {
    
        let canSwitch = (holdings.count - 1) >= max(index, index2)
        if canSwitch {
            holdings.swapAt(index, index2)
            saveToCoreData()
        }
        
    }
    
    public func removeStockFromIndex(_ index: Int)  {
            holdings.remove(at: index)
            saveToCoreData()
    }
    
    private func updateHoldingIndexRanks() {
        
        if holdings.isEmpty {
            return
        }
        
        for idx in 0...holdings.count - 1 {
            let stock = holdings[idx]
            stock.rankInPortfolio = idx
        }
    }
    
}
