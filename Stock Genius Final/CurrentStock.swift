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
    var acquiredPrice : Float = 0
    let currentPriceKey = "currentPrice"
    let lastClosePriceKey = "lastClosePrice"
    let sincePeriodBeginPriceKey = "sincePeriodStartPrice"
    var lastToggleSegment : IndividualSegmentType?
    var graphHistory : [Date : Float] = [:]
    var dailyHistory : [Date : Float] = [:]
    var newsItems: [NewsItem] = []
    var stockTwitsMessages : [Int : STMessage] = [:]
    
    // company info
    var industry : String = "-"
    var website : String = "-"
    var companyDescription : String = ""
    var ceo : String = "-"
    var sector : String = "-"
    var marketCap : Float = 0
    var peRatio : Float = 0
    var fiftyTwoWeekHigh : Float = 0
    var fiftyTwoWeekLow : Float = 0
    var ytdChange : Float = 0
    
    
    public func updateValuesFromCoreDataStock(_ stock: SGStock) {
        adjPriceCurrent = stock.lastPrice
        ticker = stock.ticker ?? ticker
        companyName = stock.companyName ?? companyName
        adjPriceLastClose = stock.previousClose
        rankInPortfolio = Int(stock.indexInPortfolio)
    }
    
    public func updateValuesFromSymbolResult(_ result: SymbolResult) {
        ticker = result.ticker
        companyName = result.name
    }
    
    public func updateValesFromTrendingResult(_ result: [String : Any]) {
        ticker = result["symbol"] as? String ?? ticker
        companyName = result["title"] as? String ?? companyName
    }

    public func updatePricesFromCache() {
        
        let cacheDictionary = UserDefaults.standard.object(forKey: DataStore.shared.currentPricesKey) as? [String : [String : Float]]
        let stockDictionary = cacheDictionary?[ticker]
        let cachedCurrentPrice = stockDictionary?[currentPriceKey]
        let cachedlastClosePrice = stockDictionary?[lastClosePriceKey]
        let cachedSinceStartDatePrice = stockDictionary?[sincePeriodBeginPriceKey]
        adjPriceCurrent = cachedCurrentPrice ?? adjPriceCurrent
        adjPriceLastClose = cachedlastClosePrice ?? adjPriceLastClose
        adjPriceStartDate = cachedSinceStartDatePrice ?? adjPriceStartDate
    }
    
    public func updatePricesFromAlphaVantageResponse(_ response: [String : Any]) {
        let priceHistory = response["Time Series (Daily)"] as? [String : [String : String]] ?? [:]
        var dateCloses : [(date: Date, close: Float)] = []
        
        for (dateString, value) in priceHistory {
            let date = Date.dateFromString(dateString, dateFormat: "yyyy-MM-dd") ?? Date()
            let closingPrice = value["4. close"] ?? "0"
            let close = Float(closingPrice) ?? 0
            let dateClose = (date: date, close: close)
            dateCloses.append(dateClose)
        }
        
        dateCloses.sort(by: {$0.date > $1.date})
        
        if dateCloses.count > 1 {
            adjPriceCurrent = dateCloses[0].close
            adjPriceLastClose = dateCloses[1].close
        }
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
        let companySector = response["sector"] as? String ?? sector
        let mktCap = response["marketCap"] as? Float ?? marketCap
        let pe = response["peRatio"] as? Float ?? peRatio
        let high52 = response["week52High"] as? Float ?? fiftyTwoWeekHigh
        let low52 = response["week52Low"] as? Float ?? fiftyTwoWeekLow
        let yearToDateChange = response["ytdChange"] as? Float ?? ytdChange
        
        adjPriceCurrent = currentPrice == 0 ? adjPriceCurrent : currentPrice
        adjPriceLastClose = lastClosePrice == 0 ? adjPriceLastClose : lastClosePrice
        
        sector = companySector
        marketCap = mktCap
        peRatio = pe
        fiftyTwoWeekHigh = high52
        fiftyTwoWeekLow = low52
        ytdChange = yearToDateChange
        
        return (response["latestPrice"] != nil)
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

extension CurrentStock {
    
    public func priceLabelText(decimals: UInt) -> String {
        return adjPriceCurrent.stringWithDecimals(decimals)
    }
    
    public func priceChangeImage(isTodayReturn: Bool) -> UIImage? {
        let startPrice = isTodayReturn ? adjPriceLastClose : adjPriceStartDate
        return dollarChangeImage(startPx: startPrice, endPx: adjPriceCurrent)
    }
    
    public func percentageChangeString(isTodayReturn: Bool, decimalPlaces: Int) -> String {
        let startPrice = isTodayReturn ? adjPriceLastClose : adjPriceStartDate
        return percentageString(startPx: startPrice, endPx: adjPriceCurrent, decimalPlaces: decimalPlaces)
    }
    
    public func percentageChangeDirectionString(isTodayReturn: Bool) -> String {
        let startPrice = isTodayReturn ? adjPriceLastClose : adjPriceStartDate
        return adjPriceCurrent >= startPrice ? "+" : "-"
    }
    
    public func percentageChangeContainerColor(isTodayReturn: Bool) -> UIColor {
        let startPrice = isTodayReturn ? adjPriceLastClose : adjPriceStartDate
        return adjPriceCurrent >= startPrice ? SGConstants.mainGreenColor : SGConstants.mainRedColor
    }
    
    public func priceChangeString(isTodayReturn: Bool, decimalPlaces: UInt) -> String {
        
        let startPrice = isTodayReturn ? adjPriceLastClose : adjPriceStartDate
        let change = abs(adjPriceCurrent - startPrice)
        return change.stringWithDecimals(decimalPlaces)
    }
    
    public func priceDirectionImage(isTodayReturn: Bool) -> UIImage? {
        let startPrice = isTodayReturn ? adjPriceLastClose : adjPriceStartDate
        return adjPriceCurrent >= startPrice ? UIImage(named: "upImage") : UIImage(named: "downImage")
        
    }
    
}
