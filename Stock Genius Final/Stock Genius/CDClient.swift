//
//  CDClient.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/12/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import UIKit
import BigBoard

struct CDClient {
    
    static func updatePortfolios(dictionary: Dictionary<String, Any>)
    {
        CDClient.deleteAllPortfolioData()
        
        let currentPortfolio = dictionary["currentPortfolio"] as! Dictionary<String, Any>
        let pastPortfolios = dictionary["pastPortfolios"] as! Dictionary<String, Any>
        CDClient.updateCurrentPortfolio(dictionary: currentPortfolio)
        CDClient.updatePastPortfolios(dictionary: pastPortfolios)
        
        CDClient.saveCoreData()
    }
    
    public static func updateNewsItems(dictionary: Dictionary<String, Any>) {
    
        let newsItems = dictionary["articles"] as! Dictionary<String, Any>
        for ticker in newsItems.keys {
            let holding = coreDataHoldingFromTicker(ticker: ticker)
            if let holding = holding {
                let newsForTicker = newsItems[ticker] as! [Dictionary<String, String>]
                CDClient.updateHolding(holding, from: newsForTicker)
            }
        }
    }
    
    private static func updateHolding(_ holding: Holding, from newsItemsArray: [Dictionary<String, String>]) {
        
        CDClient.clearAllNewsItemsForHolding(holding)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var index = 0
        for newsItem in newsItemsArray {
            let newNewsItem = NewsItem(context: context)
            let excerpt = newsItem["excerpt"]!
            let url = newsItem["url"]!
            let pictureName = newsItem["pictureName"]!
            newNewsItem.excerpt = excerpt
            newNewsItem.pictureURL = pictureName // need to fix this
            newNewsItem.articleURL = url
            newNewsItem.rank = Int64(index)
            holding.addToNewsItems(newNewsItem)
            index += 1
        }
    }
    
    private static func updateCurrentPortfolio(dictionary: Dictionary<String, Any>) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let startDate = dictionary["startDate"] as! String
        let endDate = dictionary["endDate"] as! String
        let name = dictionary["name"] as! String
        
        let currentPortfolio = Portfolio(context: context)
        currentPortfolio.startDate = startDate
        currentPortfolio.endDate = endDate
        currentPortfolio.name = name
        currentPortfolio.isCurrentPortfolio = true
                
        let holdingsDictionary = dictionary["holdings"] as! Dictionary <String, Any>
        
        for idx in 1...30 {
            let holdingDictionary = holdingsDictionary["\(idx)"] as! Dictionary <String, Any>
            
            let isTrading = holdingDictionary["isTrading"] as! Bool
            let name = holdingDictionary["name"] as! String
            let note = holdingDictionary["note"] as! String
            let rank = holdingDictionary["rank"] as! Int
            let ticker = holdingDictionary["ticker"] as! String
            let startDateAdjClose = holdingDictionary["startDateAdjClose"] as! Float
            
            let holding = Holding(context: context)
            
            holding.name = name
            holding.ticker = ticker
            holding.isTrading = isTrading
            holding.note = note
            holding.rank = Int64(rank)
            holding.adjPxStartDate = startDateAdjClose
            
            currentPortfolio.addToHoldings(holding)
        }
        
        let indexHolding = Holding(context: context)
        indexHolding.ticker = "SPY"
        indexHolding.name = "S&P 500 Index"
        indexHolding.isTrading = true
        indexHolding.rank = 99
        
        currentPortfolio.addToHoldings(indexHolding)
        
    }
    
    private static func updatePastPortfolios(dictionary: Dictionary<String, Any>) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for (portfolioName, portfolioDetails) in dictionary {
            let portfolio = Portfolio(context: context)
            
            portfolio.name = portfolioName
            portfolio.isCurrentPortfolio = false
            
            let portfolioDetailsDictionary = portfolioDetails as! Dictionary <String, Any>
            portfolio.startDate = portfolioDetailsDictionary["startDate"] as? String
            portfolio.endDate = portfolioDetailsDictionary["endDate"] as? String
            portfolio.note = portfolioDetailsDictionary["note"] as? String
            
            let holdings = portfolioDetailsDictionary["holdings"] as! Dictionary<String, Any>
            
            for idx in 1...10 {
                
                let holding = Holding(context: context)
                let holdingDictionary = holdings["\(idx)"] as! Dictionary<String, Any>
                
                holding.ticker = holdingDictionary["ticker"] as? String
                holding.name = holdingDictionary["name"] as? String
                holding.rank = Int64(holdingDictionary["rank"] as! Int)
                holding.startDate = portfolio.startDate
                holding.endDate = portfolio.endDate
                holding.finalAdjStartPx = holdingDictionary["startPx"] as! Float
                holding.finalAdjEndPx = holdingDictionary["endPx"] as! Float
                
                portfolio.addToHoldings(holding)
            }
            
            let indexHolding = Holding(context: context)
            indexHolding.name = "S&P 500 Index"
            indexHolding.rank = 99
            indexHolding.startDate = portfolio.startDate
            indexHolding.endDate = portfolio.endDate
            let indexDictionary =  holdings["index"] as! Dictionary<String, Any>
            indexHolding.finalAdjStartPx = indexDictionary["startPx"] as! Float
            indexHolding.finalAdjEndPx = indexDictionary["endPx"] as! Float
            
            portfolio.addToHoldings(indexHolding)
        }
    }
    
    public static func saveCoreData() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    public static func deleteAllPortfolioData () {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let portfolios = try context.fetch(Portfolio.fetchRequest()) as! [Portfolio]
            for portfolio in portfolios {
                context.delete(portfolio)
            }
        } catch {
            // don't worry about it!
        }
    }
    
    private static func clearAllNewsItemsForHolding(_ holding: Holding) {
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newsItems = holding.newsItems
        if let items = newsItems {
            for item in items {
                context.delete(item as! NewsItem)
            }
        }
    }
    
    public static func currentPortfolioFetch() -> Portfolio? {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          
        do {
            let allPortfolios = try context.fetch(Portfolio.fetchRequest()) as! [Portfolio]
            for portfolio in allPortfolios {
                if portfolio.isCurrentPortfolio {
                    return portfolio
                }
            }
        } catch {
            return nil
        }
        
        return nil
    }
    

    
    public static func pastPortfoliosFetch() -> [Portfolio] {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var pastPortfolios : [Portfolio] = []
        
        do {
            let allPortfolios = try context.fetch(Portfolio.fetchRequest()) as! [Portfolio]
            for portfolio in allPortfolios {
                if !portfolio.isCurrentPortfolio {
                    pastPortfolios.append(portfolio)
                }
            }
        } catch {
            ///whatttt
        }
        
        return pastPortfolios
    }
    

    public static func mapPricesToCoreData(bigBoardStocks: [BigBoardStock]) {
        
        for stock in bigBoardStocks {
            
            let holding = coreDataHoldingFromTicker(ticker: stock.symbol!)
            
            if let holding = holding, let previousClose = stock.previousClose, let lastTrade = stock.lastTradePriceOnly {
                holding.adjPxTminus1Day = Float(previousClose)!
                holding.adjPxCurrent = Float(lastTrade)!
            }
        }
        
        CDClient.saveCoreData()
    }
    
    public static func coreDataHoldingFromTicker(ticker: String) -> Holding? {
        
        let currentPortfolio = CDClient.currentPortfolioFetch()
        if let currentPort = currentPortfolio {
            let holdings = currentPort.holdings!
            for holding in holdings {
                let holdingTicker = (holding as! Holding).ticker
                if holdingTicker == ticker {
                    return (holding as? Holding)
                }
            }
        }
        return nil
    }
    
    public static func holdingsInOrderFrom(_ portfolio: Portfolio) -> [Holding] {
        
        var sortedHoldings : [Holding] = []
        
        let holdings = portfolio.holdings?.allObjects as? [Holding]
        if let stocks = holdings {
            sortedHoldings = stocks.sorted(by: {$0.rank < $1.rank})
        }
        
        return sortedHoldings
    }
    
    public static func newsItemsInOrderFromHolding(_ holding: Holding) -> [NewsItem] {
        var newsItems : [NewsItem] = []
        
        let items = holding.newsItems?.allObjects as? [NewsItem]
        if let items = items {
            newsItems = items.sorted(by: {$0.rank < $1.rank})
        }
        
        return newsItems
    }
    
    public static func averageReturnFromPastPortfolio(_ portfolio: Portfolio) -> Float {
        
        let holdings = portfolio.holdings?.allObjects as? [Holding]
        var returnSum : Float = 0
        var averageReturn : Float = 0
        
        if let stocks = holdings {
            for stock in stocks {
                if stock.rank <= 10 {
                    let stockReturn = (stock.finalAdjEndPx / stock.finalAdjStartPx) - 1
                    returnSum = returnSum + stockReturn
                }
            }
        }
        
        averageReturn = returnSum / 10
        return averageReturn
    }
    
    
    public static func averageReturnFromCurrentPortfolio(_ portfolio: Portfolio, todayReturn: Bool) -> Float {
        
        let holdings = portfolio.holdings?.allObjects as? [Holding]
        var returnSum : Float = 0
        var averageReturn : Float = 0
        
        if let stocks = holdings {
            for stock in stocks {
                if stock.rank <= 10 {
                    
                    let stockReturn = todayReturn ? (stock.adjPxCurrent / stock.adjPxTminus1Day) - 1 : (stock.adjPxCurrent / stock.adjPxStartDate) - 1
                    returnSum = returnSum + stockReturn
                }
            }
        }
        
        averageReturn = returnSum / 10
        return averageReturn
    }
    
    public static func indexReturnFromPastPortfolio(_ portfolio: Portfolio) -> Float {
        
        let holdings = portfolio.holdings?.allObjects as? [Holding]
        var indexReturn : Float = 0
        
        if let stocks = holdings {
            for stock in stocks {
                if stock.rank >= 98 {
                    indexReturn = (stock.finalAdjEndPx / stock.finalAdjStartPx) - 1
                }
            }
        }
        
        return indexReturn
    }
    
    public static func indexReturnFromCurrentPortfolio(_ portfolio: Portfolio, todayReturn: Bool) -> Float {
        
        let holdings = portfolio.holdings?.allObjects as? [Holding]
        var indexReturn : Float = 0
        
        if let stocks = holdings {
            for stock in stocks {
                if stock.rank >= 98 {
                    indexReturn = todayReturn ? (stock.adjPxCurrent / stock.adjPxTminus1Day) - 1 : (stock.adjPxCurrent / stock.adjPxStartDate) - 1
                }
            }
        }
        
        return indexReturn
    }
    
    
}
