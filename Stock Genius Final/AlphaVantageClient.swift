//
//  AlphaVantageClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/6/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Alamofire

protocol AlphaVantageClientDelegate: class {
    func pricePullComplete(success: Bool)
    func pricePullInProgressFromAV(percentageComplete: Float)
}

class AlphaVantageClient: NSObject {
    
    public static let shared = AlphaVantageClient()
    let dateComponents = DateComponents()
    let dateFormatter = DateFormatter()
    let userCalendar = Calendar.current
    var delegate : AlphaVantageClientDelegate?
    
    
    public func updatePricesForCurrentPortfolio() {
        
        var holdingsPlusIndex : [CurrentStock] = DataStore.shared.currentPortfolio.holdings
        holdingsPlusIndex.append(DataStore.shared.currentPortfolio.index)
        
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        var requestsCompleted = 0
        
        for stock in holdingsPlusIndex {
            let requestURL = urlStringForStock(stock)
            let request = Alamofire.request(requestURL)
            
            request.response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(), completionHandler: { (response) in
                let dictionary = response.value as! Dictionary<String, Any>
                self.mapPricesToStock(stock, response: dictionary)
                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                requestsCompleted += 1
                print("\(requestsCompleted)")
                if requestsCompleted == 31 {
                    DispatchQueue.main.async {
                        self.delegate?.pricePullComplete(success: true)
                    }
                } else {
                    self.delegate?.pricePullInProgressFromAV(percentageComplete: Float(requestsCompleted) / 31.0)
                }

            })
        }
    
    }
    
    public func pullPricesChained(startingIndex: Int) {
        var holdingsPlusIndex : [CurrentStock] = DataStore.shared.currentPortfolio.holdings
        holdingsPlusIndex.append(DataStore.shared.currentPortfolio.index)
        let currentStockBeingPull = holdingsPlusIndex[startingIndex]
        pullPriceForSingleStock(currentStockBeingPull, index: startingIndex)
    }
    
    private func pullPriceForSingleStock(_ stock: CurrentStock, index: Int) {
    
        let requestURL = urlStringForStock(stock)
        let request = Alamofire.request(requestURL)
        
        request.responseJSON(completionHandler: { (response) in
            
            let dictionary = response.value as! Dictionary<String, Any>
            self.mapPricesToStock(stock, response: dictionary)
            print("\(index)")
            if index == 30 {
                self.delegate?.pricePullComplete(success: true)
            } else {
                self.pullPricesChained(startingIndex: index + 1)
            }
        })

    }
    
    private func mapPricesToStock(_ stock: CurrentStock, response: Dictionary<String, Any>) {
        stock.adjPriceCurrent = currentPriceFromResponse(response) ?? 0.0
        stock.adjPriceLastClose = lastClosePriceFromResponse(response) ?? 0.0
        let startDate = stock.startDateFromString(DataStore.shared.currentPortfolio.startDate)
        if let startDate = startDate {
            stock.adjPriceStartDate = mostRecentPriceFromDate(startDate, response: response) ?? 0.0
        }
    }
    
    private func mostRecentPriceFromDate(_ date: Date, response: Dictionary<String, Any>) -> Float? {
        
        let todayPrice = adjustedCloseForDate(date, response: response)
        
        if todayPrice != nil {
            return todayPrice!
        } else {
            for index in 1...6 {
                let newDate = userCalendar.date(byAdding: .day, value: -(index), to: Date())
                if let newDate = newDate {
                    let price = adjustedCloseForDate(newDate, response: response)
                    if let price = price {
                        return price
                    }
                }
            }
            
            return nil
        }
        
    }
    
    private func dateForMostRecentPrice(response: Dictionary<String, Any>) -> Date? {
        
        for index in 0...6 {
            
            let newDate = userCalendar.date(byAdding: .day, value: -(index), to: Date())
            if let newDate = newDate {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: newDate)
                let timeSeriesDict = response["Time Series (Daily)"] as? Dictionary<String, Dictionary<String, String>>
                if let timeSeriesDict = timeSeriesDict {
                    let keys = timeSeriesDict.keys
                    if keys.contains(dateString) {
                        return newDate
                    }
                }
            }
        }
        
        return nil
    }
    
    public func currentPriceFromResponse(_ response: Dictionary<String, Any>) -> Float? {
        
        let key = keyForCurrentPrice(response: response)
        print("\(key!)")
        if let key = key {
            let timeSeriesDict = response["Time Series (Daily)"] as? Dictionary<String, Dictionary<String, String>>
            if let timeSeriesDict = timeSeriesDict {
                let dayDict = timeSeriesDict[key]
                if let dayDict = dayDict {
                    let price = dayDict["5. adjusted close"]
                    if let price = price {
                        return Float(price)
                    }
                }
            }
        }
        
        return nil
    }
    
    public func lastClosePriceFromResponse(_ response: Dictionary<String, Any>) -> Float? {
        
        let lastCloseDate = dateForLastClose(response: response)
        if let lastCloseDate = lastCloseDate {
                return mostRecentPriceFromDate(lastCloseDate, response: response)
            }
        
        return nil
        
    }
    
    private func adjustedCloseForDate(_ date: Date, response: Dictionary<String, Any>) -> Float? {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let primaryKey = dateFormatter.string(from: date)
        
        let timeSeriesDict = response["Time Series (Daily)"] as? Dictionary<String, Dictionary<String, String>>
        if let timeSeriesDict = timeSeriesDict {
            let dayDict = timeSeriesDict[primaryKey]
             if let dayDict = dayDict {
                let price = dayDict["5. adjusted close"]
                if let price = price {
                    return Float(price)
                }
             }
        }
        
        return nil
        
    }
    
    private func lastUpdateKeyFromResponse(_ response: Dictionary<String, Any>) -> String? {
        let metaDataDict = response["Meta Data"] as? Dictionary<String, String>
        if let metaDataDict = metaDataDict {
            return metaDataDict["3. Last Refreshed"]
        }
        
        return nil
    }
    
    private func keyForCurrentPrice(response: Dictionary<String, Any>) -> String? {
        
        let metaDataDict = response["Meta Data"] as? Dictionary<String, String>
        let fullDateString = metaDataDict?["3. Last Refreshed"]
        if let fullDateString = fullDateString {
            let extraChars = fullDateString.characters.count - 10
            let endIndex = fullDateString.index(fullDateString.endIndex, offsetBy: -extraChars)
            return fullDateString.substring(to: endIndex)
        } else {
            return nil
        }
        
        
        
        
    }
    
    private func dateForLastClose(response: Dictionary<String, Any>) -> Date? {
        
        let fullTodayKey = keyForCurrentPrice(response: response)
        let shortKey = fullTodayKey?.components(separatedBy: " ")[0]
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let shortKey = shortKey {
            let shortDate = dateFormatter.date(from: shortKey)
            if let shortDate = shortDate {
                let newDate = userCalendar.date(byAdding: .day, value: -1, to: shortDate)
                return newDate
            }
        }
        
        return nil
    }
    
    private func urlStringForStock(_ stock: CurrentStock) -> String {
        let ticker = stock.ticker
        return "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=" + ticker + "&apikey=" + DataStore.shared.APIKey
    }
    
    
    
    

    
    
    
    

}
