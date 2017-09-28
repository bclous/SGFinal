//
//  CDClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CDClient: NSObject {
    
    
    public static func fetchWatchListPortfolio() -> SGPortfolio {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let portfolios = try context.fetch(SGPortfolio.fetchRequest()) as [SGPortfolio]
            let watchlist = CDClient.portfolioWithNameFromPortfolios(name: "watchlist", portfolios: portfolios)
            if let watchlist = watchlist {
                return watchlist
            } else {
                return CDClient.createCoreDataWatchListPortfolio()
            }
        } catch {
            return CDClient.createCoreDataWatchListPortfolio()
        }
    }
    
    public static func createCoreDataWatchListPortfolio() -> SGPortfolio {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataWatchList = SGPortfolio(context: context)
        coreDataWatchList.name = "watchlist"
        coreDataWatchList.lastPriceUpdate = NSDate()
        coreDataWatchList.holdings = NSSet()
        return coreDataWatchList
    }
    
    public static func saveWatchlistPortfolio(_ portfolio: WatchListPortfolio) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataPortfolio = CDClient.fetchWatchListPortfolio()
        
        let coreDataHoldings : [SGStock] = coreDataPortfolio.holdings?.allObjects as? [SGStock] ?? []
        
        for holding in coreDataHoldings {
            coreDataPortfolio.removeFromHoldings(holding)
        }
        
        CDClient.saveContext()
        
        for stock in portfolio.holdings {
            print("\(stock.ticker)")
            let newStock = SGStock(context: context)
            newStock.ticker = stock.ticker
            newStock.companyName = stock.companyName
            newStock.lastPrice = stock.adjPriceCurrent
            newStock.previousClose = stock.adjPriceLastClose
            newStock.indexInPortfolio = Int64(stock.rankInPortfolio)
            newStock.portfolio = coreDataPortfolio
            coreDataPortfolio.addToHoldings(newStock)
            CDClient.saveContext()
        }
    }
    
    private static func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    private static func portfolioWithNameFromPortfolios(name: String, portfolios: [SGPortfolio]) -> SGPortfolio? {
        
        portfolios.filter { (portfolio) -> Bool in
            portfolio.name == name
        }
        
        if portfolios.count > 0 {
            return portfolios[0]
        } else {
            return nil
        }
    }
    
    
    

}
