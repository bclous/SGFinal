//
//  CDClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CDClient: NSObject {
    
    
        public static func fetchPortfolioWithName(_ name: String) -> SGPortfolio? {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let portfolios = try context.fetch(SGPortfolio.fetchRequest()) as [SGPortfolio]
            for portfolio in portfolios {
                if portfolio.name == name {
                    return portfolio
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    public static func saveWatchlistPortfolio(_ portfolio: WatchListPortfolio) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let watchlist = SGPortfolio(context: context)
        watchlist.name = portfolio.name
        watchlist.lastPriceUpdate = portfolio.lastUpdated as? NSDate
        for holding in portfolio.holdings {
            let newStock = SGStock(context: context)
            newStock.ticker = holding.ticker
            newStock.companyName = holding.companyName
            newStock.lastPrice = holding.adjPriceCurrent
            newStock.previousClose = holding.adjPriceLastClose
            newStock.indexInPortfolio = Int64(holding.rankInPortfolio)
            newStock.portfolio = watchlist
            watchlist.addToHoldings(newStock)
        }
        CDClient.saveContext()

    }
    
    private static func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    private func deleteAllWatchlistPortfolioData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let portfolios = try context.fetch(SGPortfolio.fetchRequest()) as [SGPortfolio]
            for portfolio in portfolios {
                context.delete(portfolio)
            }
        } catch {
            // do nothing
        }
    }
    
    
    

}
