//
//  AlphaVantageClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/6/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Alamofire

enum AlphaVantageCallType {
    case intraday
    case shortHistory
    case longHistory
}

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
    
    let apiPrefix = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol="
    let apiKeySegment = "&apikey="
    var apiKey = "5875"
    
    let iexSingleStockPrefix = "https://api.iextrading.com/1.0/stock/"
    let iexSingStockSuffix = "/quote"
    let iexMultipleStockPrefix = "https://api.iextrading.com/1.0/tops?symbols="
    let iexGraphSuffix = "/chart/5y"
    let iexDailyGraphSuffix = "/chart/1d"
    let symbolsEndpoint = "https://api.iextrading.com/1.0/ref-data/symbols"
    
    
    public func pullAvailableTickersFromIEX(completion: @escaping (_ success: Bool) -> ()) {
        
        let requestURL = symbolsEndpoint
        let request =  Alamofire.request(requestURL)
        
        request.responseJSON { (response) in
            if response.result.isFailure {
                completion(false)
            } else {
                let symbolsArray : [[String : Any]] = response.value as? [[String : Any]] ?? [[:]]
                if symbolsArray.isEmpty {
                    completion(false)
                } else {
                    DataStore.shared.updateAvailableSymbolsFromResponse(symbolsArray)
                    completion(true)
                }
            }
        }   
    }
    
    public func updatePricesForStocks(_ stocks: [CurrentStock], completion: @escaping (_ success: Bool) -> ()) {
        
        let tickerString = tickerStringFromStocks(stocks)
        let requestURL = iexSingStockSuffix + "market/batch?symbols=" + tickerString + "=quote"
        let request = Alamofire.request(requestURL)
    
        request.responseJSON { (response) in
            if response.result.isFailure {
                completion(false)
            } else {
                let tickerDictionary = response.value as? [String : [String : [String : Any]]] ?? [:]
                for (key, value) in tickerDictionary {
                    let stockForKey = self.stockFromTickerFromArrayOfStocks(stocks, ticker: key)
                    if let stock = stockForKey {
                        let stockDictionary = value["quote"] ?? [:]
                        if !stockDictionary.isEmpty {
                            let result = stock.updatePricesWithInvestorsExchangeResponse(stockDictionary)
                        }
                    }
                }
                completion(true)
            }
        }
    }
    
    private func stockFromTickerFromArrayOfStocks(_ stocks: [CurrentStock], ticker: String) -> CurrentStock? {
        
        let matchingStocks = stocks.filter { (stock) -> Bool in
            stock.ticker == ticker
        }
        if matchingStocks.count > 0 {
            return matchingStocks[0]
        } else {
            return nil
        }
        
    }
   
    
    public func pullPriceAndLastCloseFromIEXForCurrentPortfolio(completion: @escaping (_ goodStocks: [CurrentStock], _ badStocks: [CurrentStock]) -> ()) {
        
        var holdings = DataStore.shared.currentPortfolio.holdings
        var tradingHoldings : [CurrentStock] = []
        
        for stock in holdings {
            if stock.isTrading {
                tradingHoldings.append(stock)
            }
        }
        
        let index = DataStore.shared.currentPortfolio.index
        var goodStocks : [CurrentStock] = []
        var badStocks : [CurrentStock] = []
        
        tradingHoldings.append(index)
        
        let group = DispatchGroup()
        
        for index in 0...holdings.count - 1 {
            group.enter()
            iexDataForSingleStock(tradingHoldings[index], completion: { (success) in
                if success {
                    goodStocks.append(holdings[index])
                } else {
                    badStocks.append(holdings[index])
                }
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            completion(goodStocks, badStocks)
        }
        
    }
    
    public func updateCurrentPriceOnlyForCurrentPortfolio(completion: @escaping (_ success: Bool) -> ()) {
    
        let requestURL = iexMultipleStockPrefix + DataStore.shared.currentPortfolio.allTickerStringForPricePull()
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { (response) in
            
            if response.result.isFailure {
                completion(false)
            } else {
                let responseArray : [Any] = response.value as? [Any] ?? [ ]
                DataStore.shared.currentPortfolio.updatePricesFromResponse(responseArray)
                completion(true)
            }
        }
    }
    
    public func iexDataForSingleStock(_ stock: CurrentStock, completion: @escaping (_ success: Bool) -> ()) {
        
        let requestURL = iexSingleStockPrefix + stock.ticker + iexSingStockSuffix
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { (response) in
            if response.result.isFailure {
                completion(false)
            } else {
                let result = stock.updatePricesWithInvestorsExchangeResponse(response.value as! [String : Any])
                completion(result)
            }
        }

    }
    
    public func pullNewsForStock(_ stock: CurrentStock, numberOfArticles: Int, completion: @escaping (_ success: Bool) -> ()) {

        let requestURL = iexSingleStockPrefix + stock.ticker + "/news/last/" + String(numberOfArticles)
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { (response) in
            if response.result.isFailure {
                completion(false)
            } else {
                let newsResponse = response.value as? [[String : String]] ?? []
                if newsResponse.count > 0 {
                    stock.updateNewsItemsWithResponse(newsResponse)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }

    }
    
    public func pullGraphDataForStock(_ stock: CurrentStock, completion: @escaping (_ success: Bool) -> () ) {
        
        let requestURL = iexSingleStockPrefix + stock.ticker + iexGraphSuffix
        
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { (response) in
            if response.result.isFailure {
                completion(false)
            } else {
                let graphData = response.value as? [[String : Any]] ?? []
                if graphData.count > 0 {
                    stock.updateGraphDataWithIEXResponse(graphData)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }

    }
    
    public func pullDailyGraphDataForStock(_ stock: CurrentStock, completion: @escaping (_ success: Bool) -> ()) {
        
        let requestURL = iexSingleStockPrefix + stock.ticker + iexDailyGraphSuffix
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { (response) in
            if response.result.isFailure {
                completion(false)
            } else {
                let graphData = response.value as? [[String : Any]] ?? []
                if graphData.count > 0 {
                    stock.updateDailyGraphDataWithIEXResponse(graphData)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func tickerStringFromStocks(_ stocks: [CurrentStock]) -> String {
        var tickerString = ""
        for index in 0...stocks.count - 1 {
            let isLastStock = index == stocks.count - 1
            let stock = stocks[index]
            tickerString.append(stock.ticker)
            if !isLastStock {
                tickerString.append(",")
            }
        }
        
        return tickerString
    }
    
}
