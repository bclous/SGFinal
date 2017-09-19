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
    var lastToggleSegment : IndividualSegmentType = .sixMonths
    var graphData : [(x: Date, y: Float)] = []
    var graphShortHistory : [Date : Float] = [:]
    var graphLongHistory : [Date : Float] = [:]
    var priceHistory : [String : Float] = [:]
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
    
    public func updatePricesWithResponse(_ response: [String : Any], callType: AlphaVantageCallType) {
        
        updatePriceHistoryFromResponse(response)
        updateHistoryFlagsFromResponse(response, callType: callType)
        updateAvailablePriceHistoryDates()
        updateMainPrices()
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
    
    public func updateNewsItemsWithResponse(_ response: [[String : String]]) {
        
        newsItems.removeAll()
        for newsItemResponse in response {
            let newsItem = NewsItem(articleResponse: newsItemResponse)
            newsItems.append(newsItem)
        }
        newsItems.sort(by: {$0.date > $1.date})
    }
    
    private func updatePriceHistoryFromResponse(_ response: [String : Any]) {
        
        let priceDictionary = response["Time Series (Daily)"] as? [String : [String : String]] ?? [:]
        for (key, value) in priceDictionary {
            let adjustedCloseString = value["5. adjusted close"] ?? ""
            let adjustedClose = Float(adjustedCloseString)
            if adjustedClose != nil && adjustedClose != 0 {
                priceHistory.updateValue(adjustedClose!, forKey: key)
            }
        }
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
    
    private func updateHistoryFlagsFromResponse(_ response : [String : Any], callType: AlphaVantageCallType) {
        
        let priceDictionary = response["Time Series (Daily)"] as? [String : [String : String]] ?? [:]
    
        if priceDictionary.count != 0 {
            switch callType {
            case .intraday:
                hasIntraDayPriceHistory = true
                hasShortPriceHistory = true
            case .shortHistory:
                hasIntraDayPriceHistory = true
                hasShortPriceHistory = true
            case .longHistory:
                hasLongPriceHistory = true
                hasShortPriceHistory = true
                hasIntraDayPriceHistory = true
            }
        }
        
    }
    
    private func updateMainPrices() {
        
        let currentKey = currentPriceKey(availableDates: availableDates) ?? ""
        let lastCloseKey = lastClosePriceKey(availableDates: availableDates) ?? ""
        let sinceStartDateKey = sinceStartPeriodPriceKey(availableDates: availableDates) ?? ""
        
        adjPriceCurrent = priceHistory[currentKey] ?? 0
        adjPriceLastClose = priceHistory[lastCloseKey] ?? 0
        adjPriceStartDate = priceHistory[sinceStartDateKey] ?? 0
        
    }
    
    private func updateAvailablePriceHistoryDates() {
        
        var dates : [Date] = []
        
        for (key, _) in priceHistory {
            let date = Date.dateFromString(key, dateFormat: "yyyy-MM-dd")
            if let date = date {
                dates.append(date)
            }
        }
        dates.sort(by: {$0 > $1})
        availableDates = dates
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
    
    
    // functions for graph
    
    public func updateGraphData() {
        
        if graphDictionary().isEmpty {
            updateGraphHistory()
        }
        
        let history = graphDictionary()
        
        graphData.removeAll()
        
        let startingDate = startingDateForSegmentType(lastToggleSegment) ?? Date()
        
        for (key, value) in history {
            if key >= startingDate {
                let day = (x: key, y: value)
                graphData.append(day)
            }
            
        }
        
        graphData.sort(by: {$0.x < $1.x})
        
    }
    
    private func updateGraphHistory() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for (key, value) in priceHistory {
            let date = dateFormatter.date(from: key)
            if let date = date {
                if isLongHistory() {
                    graphLongHistory.updateValue(value, forKey: date)
                } else {
                    graphShortHistory.updateValue(value, forKey: date)
                }
            }
        }

    }
    
    public func performanceInfoFromType(_ type: IndividualSegmentType, noEarlierThan date: Date?) -> (return: String, color: UIColor) {
        
        var startingPrice : Float = 0
        if let date = date {
            startingPrice = graphDictionary()[date] ?? 0
        } else {
            startingPrice = graphData[0].y
        }
        let endPrice = graphData[graphData.count - 1].y
        
        if startingPrice == 0 || endPrice == 0 {
            return (return: "-", color: SGConstants.mainGreenColor)
        } else {
            let isPositive = endPrice >= startingPrice
            return (percentageString(startPx: startingPrice, endPx: endPrice, decimalPlaces: 2), isPositive ? SGConstants.mainGreenColor : SGConstants.mainRedColor )
        }

    }
    
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
    
    
    private func priceHistorySinceAndIncludingDate(_ date: Date) -> [Date : Float] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
     
        NSLog("started priceHistorySince and including")
        
        var history : [Date : Float] = [ : ]
        
        for (key, value) in priceHistory {
            let pastDate = dateFormatter.date(from: key)
            if let pastDate = pastDate {
                if pastDate >= date {
                    history.updateValue(value, forKey: pastDate)
                }
            }
        }
        
        NSLog("finished price history since and including date")
        
        return history
        
    }
    
    private func isLongHistory() -> Bool {
        switch lastToggleSegment {
        case .today, .oneWeek, .oneMonth, .threeMonths, .sinceStartDate:
            return false
        case .sixMonths, .oneYear, .threeYears, .fiveYears:
            return true
        }
    }
    
    private func graphDictionary() -> [Date : Float] {
        
        return isLongHistory() ? graphLongHistory : graphShortHistory
        
    }
    
    
}
