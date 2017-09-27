//
//  CDClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CDClient: NSObject {
    
    
    private static func fetchPortfolioWithName(_ name: String) -> SGPortfolio? {
        
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
