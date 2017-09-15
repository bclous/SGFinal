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
    var priceHistory : [Date : Float]
    var hasShortPriceHistory : Bool
    var hasLongPriceHistory : Bool
    var hasIntraDayPriceHistory: Bool
    var currentPriceAPIKey : String
    var lastClosePriceAPIKey : String
    var sincePeriodBeginAPIKey : String
    let currentPriceKey = "currentPrice"
    let lastClosePriceKey = "lastClosePrice"
    let sincePeriodBeginPriceKey = "sincePeriodStartPrice"
    var stockPriceDays : [StockPriceDay]
    var lastToggleSegment : IndividualSegmentType = .sixMonths
    
    override init() {
        self.isTrading = true
        self.adjPriceCurrent = 0
        self.adjPriceStartDate = 0
        self.adjPriceLastClose = 0
        self.acquiredPrice = 0
        self.startingPriceHardCode = 0
        self.priceHistory = [:]
        self.hasShortPriceHistory = false
        self.hasLongPriceHistory = false
        self.hasIntraDayPriceHistory = false
        self.currentPriceAPIKey = ""
        self.lastClosePriceAPIKey = ""
        self.sincePeriodBeginAPIKey = ""
        self.stockPriceDays = []
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
    
    public func updatePricesWithResponse(_ response: [String : Any], callType: AlphaVantageCallType) {
        updateAPIKeysWithResponse(response)
        let priceDictionary = response["Time Series (Daily)"] as? [String : Any]
        updateCurrentPrice(timeSeries: priceDictionary)
        updateLastClosePrice(timeSeries: priceDictionary)
        updateSincePeriodBegin(timeSeries: priceDictionary)
        updateStockPriceDays(timeSeries: priceDictionary)
        updateHistoryFlags(timeSeries: priceDictionary, callType: callType)
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

    
    public func addToPriceHistory(date: Date, closingPrice: Float) {
        priceHistory.updateValue(closingPrice, forKey: date)
    }
    
    public func dateFromString(_ dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)
        return date
    }
    

    // helper methods to update prices
    
    private func updateHistoryFlags(timeSeries: [String : Any]?, callType: AlphaVantageCallType) {
        if let timeSeries = timeSeries {
            if timeSeries.count != 0 {
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
    }
    
    private func updateStockPriceDays(timeSeries: [String : Any]?) {
        
        if let timeSeries = timeSeries {
            stockPriceDays.removeAll()
            for (key, value) in timeSeries {
                let stockPriceDate = StockPriceDay(dateKey: key, responseValue: value as! [String : String])
                stockPriceDays.append(stockPriceDate)
            }
        }
        stockPriceDays.sort(by: {$0.date > $1.date})

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
    
    
    // functions for graph
    
    public func performanceReturnFromType(_ type: IndividualSegmentType) -> String {
        
        let data = graphDataFromType(type)
        
        if data.count > 0 {
            let firstDay = data[0].y
            let lastDay = data[data.count - 1].y
            return percentageString(startPx: firstDay, endPx: lastDay, decimalPlaces: 2)
        } else {
            return "-"
        }

    }
    
    public func performanceColorFromType(_ type: IndividualSegmentType) -> UIColor {
        
        let data = graphDataFromType(type)
        
        if data.count > 0 {
            let firstDay = data[0].y
            let lastDay = data[data.count - 1].y
            return lastDay >= firstDay ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        } else {
            return SGConstants.mainGreenColor
        }

    }
    
    public func graphDataFromType(_ type: IndividualSegmentType) -> [(x: Date, y: Float)] {
        
        var graphData : [(x: Date, y: Float)] = []
        let date = startingDateForSegmentType(type)
        
        let data = stockPriceDaysSinceDate(date)
        
        if data.count > 0 {
            for index in 0...data.count - 1 {
                let day = data[index]
                let x = day.date
                let y = day.adjustedClose
                let value = (x,y)
                graphData.append(value)
            }
        }
        
        graphData.sort { (first, second) -> Bool in
            first.x < second.x
        }
        
        return graphData
    }
    
    private func startingDateForSegmentType(_ type: IndividualSegmentType) -> Date? {
        
        let today = Date()
        
        switch type {
        case .today:
            return today.dateByAdding(value: -1, component: .day)
        case .oneWeek:
            return today.dateByAdding(value: -7, component: .day)
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
    
    private func stockPriceDaysSinceDate(_ date: Date?) -> [StockPriceDay] {
        
        var graphData : [StockPriceDay] = []
        
        if let date = date {
            for stockPriceDay in stockPriceDays {
                
                
                
                if stockPriceDay.date.dateIsOnSameDayOrAfter(date) {
                    graphData.append(stockPriceDay)
                } else {
                   // print("didn't include: \(stockPriceDay.date) for starting date: \(date)")
                }
            }
        }
        graphData.sort(by: {$0.date < $1.date})
        return graphData
    }
    

    

    
    


}
