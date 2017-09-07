//
//  CurrentStock.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentStock: Stock {
    
    var adjPriceCurrent : Float
    var adjPriceStartDate : Float
    var adjPriceLastClose : Float
    var isTrading : Bool
    var acquiredPrice : Float
    var startingPriceHardCode : Float
    var currentPriceAPIKey : String
    var lastClosePriceAPIKey : String
    var sincePeriodBeginAPIKey : String
    let currentPriceKey = "currentPrice"
    let lastClosePriceKey = "lastClosePrice"
    let sincePeriodBeginPriceKey = "sincePeriodStartPrice"
    
    override init() {
        self.isTrading = true
        self.adjPriceCurrent = 0
        self.adjPriceStartDate = 0
        self.adjPriceLastClose = 0
        self.acquiredPrice = 0
        self.startingPriceHardCode = 0
        currentPriceAPIKey = ""
        lastClosePriceAPIKey = ""
        sincePeriodBeginAPIKey = ""
        super.init()
    }
    
    public func updatePricesFromCache() {
        let cacheDictionary = UserDefaults.standard.object(forKey: DataStore.shared.currentPricesKey) as? [String : [String : Float]]
        let stockDictionary = cacheDictionary?[ticker]
        let cachedCurrentPrice = stockDictionary?[currentPriceKey] ?? 0.0
        let cachedlastClosePrice = stockDictionary?[lastClosePriceKey] ?? 0.0
        let cachedSinceStartDatePrice = stockDictionary?[sincePeriodBeginPriceKey] ?? 0.0
        adjPriceCurrent = cachedCurrentPrice
        adjPriceLastClose = cachedlastClosePrice
        adjPriceStartDate = cachedSinceStartDatePrice
    }
    
    public func updateCurrentStockValues(dictionary: Dictionary<String, Any>) {
        isTrading = dictionary["isTrading"] as? Bool ?? true
        companyName = dictionary["name"] as? String ?? ""
        note = dictionary["note"] as? String ?? ""
        rankInPortfolio = dictionary["rank"] as? Int ?? 99
        ticker = dictionary["ticker"] as? String ?? ""
        acquiredPrice = dictionary["acquiredPrice"] as? Float ?? 0.0
        startingPriceHardCode = dictionary["startingPriceHardCode"] as? Float ?? 0.0
        
    }
    
    public func updatePricesWithResponse(_ response: [String : Any]) {
        updateAPIKeysWithResponse(response)
        let priceDictionary = response["Time Series (Daily)"] as? [String : Any]
        updateCurrentPrice(timeSeries: priceDictionary)
        updateLastClosePrice(timeSeries: priceDictionary)
        updateSincePeriodBegin(timeSeries: priceDictionary)
    }
    
    public func percentageReturn(isTodayReturn: Bool) -> Float {
        
        let todayStartingPrice = isTrading ? adjPriceLastClose : acquiredPrice
        let periodStartingPrice = isTrading ? adjPriceStartDate : startingPriceHardCode
        let currentPrice = isTrading ? adjPriceCurrent : acquiredPrice
        
        if isTodayReturn {
            return todayStartingPrice == 0 ? 0 : currentPrice / todayStartingPrice - 1
        } else {
            return periodStartingPrice == 0 ? 0 : currentPrice / periodStartingPrice - 1
        }
    }
    
    
    
    // helper methods to update prices
    
    private func updatePricesFromCachedValues() {
        let cachedStocks = UserDefaults.standard.object(forKey: DataStore.shared.currentPricesKey) as? [String : [String : Float]]
        let cachedStock = cachedStocks?[ticker] as? [String : Float]
        
    }
    
    private func updateCurrentPrice(timeSeries: [String : Any]?) {
        let dayDictionary = timeSeries?[currentPriceAPIKey] as? [String : Any]
        let priceString =  dayDictionary?["5. adjusted close"] as? String ?? ""
        adjPriceCurrent = Float(priceString) ?? 0
    }
    
    private func updateLastClosePrice(timeSeries: [String : Any]?) {
        let dayDictionary = timeSeries?[lastClosePriceAPIKey] as? [String : Any]
        let priceString =  dayDictionary?["5. adjusted close"] as? String ?? ""
        adjPriceLastClose = Float(priceString) ?? 0
    }
    
    private func updateSincePeriodBegin(timeSeries: [String : Any]?) {
        let dayDictionary = timeSeries?[sincePeriodBeginAPIKey] as? [String : Any]
        let priceString =  dayDictionary?["5. adjusted close"] as? String ?? ""
        adjPriceStartDate = Float(priceString) ?? 0
    }
    
    private func updateAPIKeysWithResponse(_ response: [String : Any]) {
        let availableDates = availableDatesFromResponse(response)
        currentPriceAPIKey = currentPriceKey(availableDates: availableDates) ?? ""
        lastClosePriceAPIKey = lastClosePriceKey(availableDates: availableDates) ?? ""
        sincePeriodBeginAPIKey = sinceStartPeriodPriceKey(availableDates: availableDates) ?? ""
    }

    private func availableDatesFromResponse(_ response: [String : Any]) -> [Date] {
        
        var dates : [Date] = []
        
        let timeSeries = response["Time Series (Daily)"] as? [String : Any]
        let keys = timeSeries?.keys
        if let keys = keys {
            for key in keys {
                let date = Date.dateFromString(key, dateFormat: "yyyy-MM-dd")
                if let date = date {
                    dates.append(date)
                }
            }
        }
        
        dates.sort(by: {$0 > $1})
        return dates
        
    }
    
    private func currentPriceKey(availableDates: [Date]) -> String? {
        if availableDates.count > 0 {
            let key = availableDates[0].string(withFormat: "yyyy-MM-dd")
            return key
        } else {
            return nil
        }
    }
    
    private func lastClosePriceKey(availableDates: [Date]) -> String? {
        if availableDates.count > 1 {
            
            if Date().timeIntervalSince(availableDates[0]) > 388800 {
                let key = availableDates[0].string(withFormat: "yyyy-MM-dd")
                return key
            } else {
                let key = availableDates[1].string(withFormat: "yyyy-MM-dd")
                return key
            }
        } else {
            return nil
        }
    }
    
    private func sinceStartPeriodPriceKey(availableDates: [Date]) -> String? {
        let startDate = DataStore.shared.currentPortfolio.dateForPeriodBegin()
        if let startDate = startDate {
            for date in availableDates {
                if date <= startDate {
                    return date.string(withFormat: "yyyy-MM-dd")
                }
            }
            return nil
        } else {
            return nil
        }
        
    }


}
