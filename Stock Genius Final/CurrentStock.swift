//
//  CurrentStock.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentStock: Stock {
    
    var adjPriceCurrent : Float = 0
    var adjPriceStartDate : Float = 0
    var adjPriceLastClose : Float = 0
    var isTrading : Bool = true
    var startingPriceHardCode : Float = 0
    var availableDates : [Date] = []
    var hasShortPriceHistory : Bool = false
    var hasLongPriceHistory : Bool = false
    var hasIntraDayPriceHistory: Bool = false
    var acquiredPrice : Float = 0
    let currentPriceKey = "currentPrice"
    let lastClosePriceKey = "lastClosePrice"
    let sincePeriodBeginPriceKey = "sincePeriodStartPrice"
    var lastToggleSegment : IndividualSegmentType?
    var graphHistory : [Date : Float] = [:]
    var newsItems: [NewsItem] = []
    

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
        acquiredPrice = dictionary["acquiredPrice"] as? Float ?? 0
        adjPriceStartDate = dictionary["startingPriceHardCode"] as? Float ?? adjPriceStartDate
    }
    
    public func pullGraphData(completion: @escaping (_ success: Bool) -> ()) {
        AlphaVantageClient.shared.pullGraphDataForStock(self) { (success) in
            completion(success)
        }
    }
    
    public func pullNewsData(numberOfArticles: Int, completion: @escaping (_ success: Bool) -> ()) {
        AlphaVantageClient.shared.pullNewsForStock(self, numberOfArticles: numberOfArticles) { (success) in
            completion(success)
        }
    }
    
    public func updatePricesWithInvestorsExchangeResponse(_ response: [String : Any]) -> Bool {
        
        let currentPrice = response["latestPrice"] as? Float ?? 0
        let lastClosePrice = response["previousClose"] as? Float ?? 0
        
        print("ticker: \(self.ticker): current - \(currentPrice), lastClose - \(lastClosePrice)")
        
        let isGoodResponse = currentPrice != 0 && lastClosePrice != 0
        
        if isGoodResponse {
            adjPriceCurrent = currentPrice
            adjPriceLastClose = lastClosePrice
            return true
        } else {
            return false
        }

    }
    
    public func updateGraphDataWithIEXResponse(_ response: [[String : Any]]) {
        
        graphHistory.removeAll()
        
        for priceDate in response {
            
            let dateString = priceDate["date"] as? String ?? ""
            let date = Date.dateFromString(dateString, dateFormat: "yyyy-MM-dd")
            let price = priceDate["close"] as? Float
            
            if let date = date, let price = price {
                graphHistory.updateValue(price, forKey: date)
            }
        }
        
    }
    
    public func graphDataForDuration(_ duration: IndividualSegmentType) -> [(x: Date, y: Float)] {
        
        var graphData : [(x: Date, y: Float)] = []
        
        let startingDate = startingDateForSegmentType(duration) ?? Date()
        
        for (key, value) in graphHistory {
            if key >= startingDate {
                let day = (x: key, y: value)
                graphData.append(day)
            }
        }
        
        graphData.sort(by: {$0.x < $1.x})
        return graphData
        
    }
    
    public func updateNewsItemsWithResponse(_ response: [[String : String]]) {
        
        newsItems.removeAll()
        for newsItemResponse in response {
            let newsItem = NewsItem(articleResponse: newsItemResponse)
            newsItems.append(newsItem)
        }
        newsItems.sort(by: {$0.date > $1.date})
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
    
    
    // functions for graph
    

    private func startingDateForSegmentType(_ type: IndividualSegmentType) -> Date? {
    
        let today = Date()
        
        switch type {
        case .today:
            let dateString = lastClosePriceKey(availableDates: availableDates) ?? ""
            return Date.dateFromString(dateString, dateFormat: "yyyy-MM-dd") ?? today.dateByAdding(value: -1, component: .day)
        case .oneWeek:
            return availableDates.count >= 6 ? availableDates[5] : today.dateByAdding(value: -7, component: .day)
        case .oneMonth:
            return today.dateByAdding(value: -1, component: .month)
        case .threeMonths:
            return today.dateByAdding(value: -3, component: .month)
        case .sixMonths:
            return today.dateByAdding(value: -6, component: .month)
        case .oneYear:
            return today.dateByAdding(value: -1, component: .year)
        case .threeYears:
            return today.dateByAdding(value: -3, component: .year)
        case .fiveYears:
            return today.dateByAdding(value: -5, component: .year)
        case .sinceStartDate:
            return DataStore.shared.currentPortfolio.dateForPeriodBegin()
        }
        
    }
    
    
}
