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
    var hasShortPriceHistory : Bool = false
    var hasLongPriceHistory : Bool = false
    var hasIntraDayPriceHistory: Bool = false
    var acquiredPrice : Float = 0
    let currentPriceKey = "currentPrice"
    let lastClosePriceKey = "lastClosePrice"
    let sincePeriodBeginPriceKey = "sincePeriodStartPrice"
    var lastToggleSegment : IndividualSegmentType?
    var graphHistory : [Date : Float] = [:]
    var dailyHistory : [Date : Float] = [:]
    var newsItems: [NewsItem] = []
    var stockTwitsMessages : [Int : STMessage] = [:]
    

    public func updatePricesFromCache() {
        
        let cacheDictionary = UserDefaults.standard.object(forKey: DataStore.shared.currentPricesKey) as? [String : [String : Float]]
        let stockDictionary = cacheDictionary?[ticker]
        let cachedCurrentPrice = stockDictionary?[currentPriceKey]
        let cachedlastClosePrice = stockDictionary?[lastClosePriceKey]
        adjPriceCurrent = cachedCurrentPrice ?? adjPriceCurrent
        adjPriceLastClose = cachedlastClosePrice ?? adjPriceLastClose
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
    
    public func updateStockTwitsMessagesFromResponse(_ response: [String : Any]) {
        let messagesDictionary = response["messages"] as? [[String : Any]] ?? [[:]]
        for messageResponse in messagesDictionary {
            let messageID = messageResponse["id"] as? Int ?? 0
            let message = STMessage(response: messageResponse)
            stockTwitsMessages.updateValue(message, forKey: messageID)
        }
        
    }
    
    public func stockTwitsMessagesInOrder(mostRecentFirst: Bool) -> [STMessage] {

        var messages : [STMessage] = []
        for (_, value) in stockTwitsMessages {
            messages.append(value)
        }
        
        if mostRecentFirst {
            messages.sort(by: {$0.dateCreated > $1.dateCreated})
        } else {
            messages.sort(by: {$0.dateCreated < $1.dateCreated})
        }

        return messages
    }
    
    public func pullStockTwitsMessages(completion: @escaping (_ success: Bool) -> ()) {
        StockTwitsClient.pullMessagesForStock(self) { (success) in
            completion(success)
        }
    }
    
    public func pullGraphData(completion: @escaping (_ success: Bool) -> ()) {
        AlphaVantageClient.shared.pullGraphDataForStock(self) { (success) in
            completion(success)
        }
    }
    
    public func pullDailyGraphData(completion: @escaping (_ success: Bool) -> ()) {
        AlphaVantageClient.shared.pullDailyGraphDataForStock(self) { (success) in
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
        let isGoodResponse = currentPrice != 0 && lastClosePrice != 0
        
        if isGoodResponse {
            adjPriceCurrent = currentPrice
            adjPriceLastClose = lastClosePrice
            return true
        } else {
            return false
        }

    }
    
    private func availableDates(mostRecentFirst: Bool) -> [Date] {
        
        var availableDates : [Date] = []
        
        for (key, _ ) in graphHistory {
            availableDates.append(key)
        }
        
        availableDates.sort(by: { (firstDate, secondDate) -> Bool in
            return mostRecentFirst ? secondDate < firstDate : firstDate < secondDate
        })
        
        return availableDates
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
    
    public func updateDailyGraphDataWithIEXResponse(_ response: [[String : Any]]) {
        
        dailyHistory.removeAll()
        var mostRecentTrade = adjPriceLastClose
        
        for quote in response {
            let numberOfTrades = quote["numberOfTrades"] as? Int ?? 0
            let todayString = Date().string(withFormat: "yyyy-MM-dd") ?? ""
            let minuteString = quote["minute"] as? String ?? ""
            let dateString = todayString + " " + minuteString
            let quoteDate = Date.dateFromString(dateString, dateFormat: "yyyy-MM-dd HH:mm")
            let price = quote["average"] as? Float ?? 0
            let adjustedPrice = numberOfTrades > 0 ? price : mostRecentTrade

            if let quoteDate = quoteDate {
                dailyHistory.updateValue(adjustedPrice, forKey: quoteDate)
            }
            mostRecentTrade = adjustedPrice
        }
    }
    
    public func graphDataForDuration(_ duration: IndividualSegmentType) -> [(x: Date, y: Float)] {
        
        if duration == .today {
            return dailyGraphData()
        } else {
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
    }
    
    private func dailyGraphData() -> [(x: Date, y: Float)] {
        
        var dailyData : [(x: Date, y: Float)] = []
        for (date, value) in dailyHistory {
            let quote = (x: date, y: value)
            dailyData.append(quote)
        }
        
        dailyData.sort(by: {$0.x < $1.x})
        
        return dailyData
    }
    
    public func updateNewsItemsWithResponse(_ response: [[String : String]]) {
        
        newsItems.removeAll()
        for newsItemResponse in response {
            let newsItem = NewsItem(articleResponse: newsItemResponse)
                newsItems.append(newsItem)
            
        }
        newsItems.sort(by: {$0.date > $1.date})
        filterNewsItems()
    }
    
    private func filterNewsItems() {
        
        var sourceDictionary : [String : Int] = [:]
        var filteredNewsItems :[NewsItem] = []
        
        for item in newsItems {
            let amount = sourceDictionary[item.source] ?? 0
            if amount < 3 {
                sourceDictionary.updateValue(amount+1, forKey: item.source)
                filteredNewsItems.append(item)
            }
            
        }
        
        newsItems = filteredNewsItems

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
    
    
    // functions for graph
    

    private func startingDateForSegmentType(_ type: IndividualSegmentType) -> Date? {
    
        let today = Date()
        let availableDays = availableDates(mostRecentFirst: true)
        
        switch type {
        case .today:
            return today
        case .oneWeek:
            return availableDays.count >= 6 ? availableDays[5] : today.dateByAdding(value: -7, component: .day)
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
