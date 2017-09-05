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
    func pricePullInProgressFromAV(percentageComplete: Float)
}

class AlphaVantageClient: NSObject {
    
    public static let shared = AlphaVantageClient()
    let dateComponents = DateComponents()
    let dateFormatter = DateFormatter()
    let userCalendar = Calendar.current
    var delegate : AlphaVantageClientDelegate?
    var successfulPulls = 0
    
    
    public func updatePricesForCurrentPortfolio(completion: @escaping (_ success: Bool) -> ()) {
        
        successfulPulls = 0
        var holdingsPlusIndex : [CurrentStock] = DataStore.shared.currentPortfolio.holdings
        holdingsPlusIndex.append(DataStore.shared.currentPortfolio.index)
        
        updatePricesForStocks(holdingsPlusIndex) { (goodStocks, badStocks) in
            if goodStocks.count == 31 {
                completion(true)
            } else {
                self.updatePricesForStocks(badStocks, completion: { (newGoodStocks, newBadStocks) in
                    if newBadStocks.count == 0 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        }
        
    }
    
    public func updatePricesForStocks(_ stocks: [CurrentStock], completion: @escaping (_ successfulStocks: [CurrentStock], _ unsucessfullStocks : [CurrentStock]) -> ()) {
        
        var successfulStocks : [CurrentStock] = []
        var unsuccessfulStocks : [CurrentStock] = []
        
        for stock in stocks {
            pullPricesForStock(stock, completion: { (success) in
                if success {
                    successfulStocks.append(stock)
                    self.successfulPulls += 1
                    let percentageComplete = Float(self.successfulPulls) / 31.0
                    self.delegate?.pricePullInProgressFromAV(percentageComplete: percentageComplete )
                    print("\(percentageComplete)")
                    if successfulStocks.count + unsuccessfulStocks.count == stocks.count {
                        completion(successfulStocks, unsuccessfulStocks)
                    }
                } else {
                    unsuccessfulStocks.append(stock)
                    if successfulStocks.count + unsuccessfulStocks.count == stocks.count {
                        completion(successfulStocks, unsuccessfulStocks)
                    }
                    
                }
            })
        }
    }
    
    
    
    
    public func pullPricesForStock(_ stock: CurrentStock, completion: @escaping (_ success: Bool) -> ()) {
        let requestURL = urlStringForStock(stock)
        let request = Alamofire.request(requestURL)
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        
        request.response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
            
            let responseDictionary = response.value as? [String : Any]
            let isGoodResponse = !response.result.isFailure && responseDictionary?.count ?? 0 > 0
            
            if isGoodResponse {
                if let responseDictionary = responseDictionary {
                    self.mapPricesToStock(stock, response: responseDictionary)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
    }
    
    private func mapPricesToStock(_ stock: CurrentStock, response: Dictionary<String, Any>) {
        stock.adjPriceCurrent = currentPriceFromResponse(response) ?? 0.0
        stock.adjPriceLastClose = lastClosePriceFromResponse(response) ?? 0.0
        let startDate = stock.startDateFromString(DataStore.shared.currentPortfolio.startDate)
        if let startDate = startDate {
            stock.adjPriceStartDate = mostRecentPriceFromDate(startDate, response: response) ?? 0.0
        }
        
        print("Mapped \(stock.ticker) for price: \(stock.adjPriceCurrent)")
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
        
        print("couldn't find key!")
        
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
