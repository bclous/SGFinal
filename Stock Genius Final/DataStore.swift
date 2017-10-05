//
//  DataStore.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import FirebaseDatabase


class DataStore: NSObject  {
    
    static let shared = DataStore()
    var currentPortfolio : CurrentPortfolio = CurrentPortfolio()
    var pastPortfolios : [PastPortfolio] = []
    var availableSymbols : [SymbolResult] = []
    var ref : DatabaseReference = Database.database().reference()
    var pricePullComplete = false
    var firebasePullComplete = false
    var APIKey = "5875"
    var totalIndexPerformance : Float = 300
    var totalStockGeniusPerformance : Float = 200
    var imageNames = ["page1Background", "girl", "mainPage1", "mainPage2", "mainPage3", "mainPage4", "mainPage5", "mainPage6","graphicPage1", "graphicPage2", "otherBackground"]
    var individualToggleState : IndividualSegmentType = .sinceStartDate
    let currentPricesKey = "currentPortfolioPrices"
    let startDateKey = "currentPortfolioStartDate"
    var watchlistPortfolio = WatchListPortfolio(name: "watchlist", lastUpdated: Date(), holdings: [], trendingStocks: [])


    var userSavedSymbols : [String] = ["AAPL", "FB", "BRKB", "TSLA"]

    private override init() {
        self.currentPortfolio = CurrentPortfolio()
        self.pastPortfolios = []
        self.ref = Database.database().reference()
        self.totalIndexPerformance = 300
        self.totalStockGeniusPerformance = 200
        super.init()
    }
    
    public func watchlistTickers() -> [String] {
        var tickers : [String] = []
        for stock in watchlistPortfolio.holdings {
            tickers.append(stock.ticker)
        }
        
        return tickers
    }
    
    public func updateTrendingStocks(completion: @escaping (_ success: Bool) -> ()) {
        StockTwitsClient.pullTrendingSymbols { (success) in
            if success {
                let stocks = self.watchlistPortfolio.trendingStocks
                AlphaVantageClient.shared.updatePricesForStocks(stocks, completion: { (success) in
                    completion(success)
                })
            } else {
                completion(false)
            }
        }
    }
    
    
    public func updateAvailableSymbols(completion: @escaping (_ success: Bool) -> ()) {
        AlphaVantageClient.shared.pullAvailableTickersFromIEX { (success) in
            completion(success)
        }
    }
    
    public func updateWatchListPortfolioFromCoreData() {
        let coreDataPortfolio =  CDClient.fetchWatchListPortfolio()
        watchlistPortfolio = WatchListPortfolio(fromCoreData: coreDataPortfolio)
    }
    
    public func updatePricesForStocks(_ stocks: [CurrentStock], completion: @escaping (_ success: Bool) -> ()) {
        AlphaVantageClient.shared.updatePricesForStocks(stocks) { (success) in
            completion(success)
        }
    }
    
    public func collectAppDataForLaunch(completion: @escaping(_ success: Bool) -> ()) {
        
        performInitialFirebasePull { (success) in
            if !success {
                completion(false)
            } else {
                self.updatePricesFromIEX(completion: { (success) in
                    completion(success)
                })
            }
        }
    }
    
    private func performInitialFirebasePull(completion: @escaping(_ success: Bool) -> ()) {
        
        FirebaseClient.shared.performInitialDatabasePull { (success, result) in
            if success {
                let result = self.populateAppWithData(dictionary: result)
                completion(result)
            } else {
                completion(false)
            }
        }
    }
    
    public func updatePricesFromIEX(completion: @escaping(_ success: Bool) -> ()) {
        
        AlphaVantageClient.shared.pullPriceAndLastCloseFromIEXForCurrentPortfolio { (goodStocks, badStocks) in
            self.currentPortfolio.cachePrices()
            completion(badStocks.count < 4)
        }
        
    }
    
    
    public func appNeedsFullUpdateOnSplashScreen() -> Bool {
        
        let cachedCurrentPortfolioStartDate = UserDefaults.standard.object(forKey: startDateKey) as? String ?? ""
        if cachedCurrentPortfolioStartDate != currentPortfolio.startDate {
            UserDefaults.standard.set(currentPortfolio.startDate, forKey: startDateKey)
            return true
        } else {
            return !priceCacheExists()
        }
    }
    
    public func priceCacheExists() -> Bool {
        if UserDefaults.standard.object(forKey: currentPricesKey) != nil {
            return true
        } else {
            return false
        }
    }

    public func pastPortfoliosString() -> String {
        
        if pastPortfolios.count == 0 {
            return "no data"
        } else {
            let startString = pastPortfolios.last?.startDateString()
            let endDateString = pastPortfolios[0].endDateString()
            
            return startString! + " - " + endDateString + " (\(pastPortfolios.count) quarters)"
        }
    }
    
    public func updateAvailableSymbolsFromResponse(_ response: [[String : Any]]) {
        availableSymbols.removeAll()
        for symbol in response {
            let availableSymbol = SymbolResult(response: symbol)
            if availableSymbol.type != "N/A" {
                availableSymbols.append(availableSymbol)
            }
        }
    }
    

    
    // private helper methods
    
    private func populateAppWithData(dictionary: [String : Any]) -> Bool {
        let currentPortfolioDictionary = dictionary["currentPortfolio"] as? Dictionary<String, Any>
        let pastPortfoliosDictionary = dictionary["pastPortfolios"] as? Dictionary<String, Any>
        let appInfo = dictionary["appInfo"] as? Dictionary<String, Any>
        let performance = dictionary["performance"] as? Dictionary<String, Float>
        let articles = dictionary["articles"] as? [String : Any]
        
        if currentPortfolioDictionary != nil && pastPortfoliosDictionary != nil && appInfo != nil && articles != nil {
            populateCurrentPortfolio(dictionary: currentPortfolioDictionary!)
            populatePastPortfolios(dictionary: pastPortfoliosDictionary!)
            populateAppInfo(dictionary: appInfo!)
            populatePerformanceData(dictionary: performance!)
            
            return true

        } else {
            return false
        }
        
    }
    
    private func populateAppInfo(dictionary: [String : Any]) {
        let apiKey = dictionary["alphaVantageAPIKey"] as? String
        if let apiKey = apiKey {
            self.APIKey = apiKey
            AlphaVantageClient.shared.apiKey = apiKey
        }
    }
    
    private func populateCurrentPortfolio(dictionary: Dictionary<String, Any>) {

        currentPortfolio.updateCurrentPortfolioValues(dictionary: dictionary)
        
        
    }
    

    private func populatePastPortfolios(dictionary: Dictionary<String, Any>) {
        
        pastPortfolios = []
        
        let keys = dictionary.keys
        
        for key in keys {
            let pastPortfolioDictionary = dictionary[key] as? Dictionary<String, Any>
            if pastPortfolioDictionary != nil {
                let pastPortfolio = PastPortfolio()
                pastPortfolio.updatePastPortfolioValues(dictionary: pastPortfolioDictionary!)
                pastPortfolios.append(pastPortfolio)
            }
        }
        
        sortPastPortfolios()
        
    }

    private func populatePerformanceData(dictionary: Dictionary<String, Float>) {
        totalIndexPerformance = dictionary["index"] ?? 200
        totalStockGeniusPerformance = dictionary["stockGenius"] ?? 300
    }
    
    private func sortPastPortfolios() {
        pastPortfolios.sort(by: {$0.rank > $1.rank})
    }
    
    public func localURLFromFileName(_ name: String) -> URL? {
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        if let docURL = directory {
            let fileName = "\(name).png"
            let localURL = docURL.appendingPathComponent(fileName)
            return localURL
        } else {
            return nil
        }
    }
    
    

}
