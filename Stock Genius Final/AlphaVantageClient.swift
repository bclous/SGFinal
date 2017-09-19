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
                print("\(response.value!)")
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
    

    public func pullPricesForStock(_ stock: CurrentStock, callType: AlphaVantageCallType, completion: @escaping (_ success: Bool) -> ()) {
        let requestURL = urlStringForStock(stock, type: callType)
        let request = Alamofire.request(requestURL)
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        
        request.response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
            
            let responseDictionary = response.value as? [String : Any]
            let isGoodResponse = !response.result.isFailure && responseDictionary?.count ?? 0 > 0 && responseDictionary != nil
            
            if isGoodResponse {
                stock.updatePricesWithResponse(responseDictionary!, callType : callType)
                NSLog("updated prices for: \(stock.ticker)")
                completion(true)
            } else {
                completion(false)
                let data = response.debugDescription
                print("\n\n\nfailed for: \(stock.ticker)\n\nResponse: \n\n \(data)")
            }
        }
    }
    
    private func urlStringForStock(_ stock: CurrentStock, type: AlphaVantageCallType) -> String {
        
        let ticker = stock.ticker
        
        switch type {
        case .intraday:
            return apiPrefix + ticker + apiKeySegment + apiKey
        case .shortHistory:
            return apiPrefix + ticker + apiKeySegment + apiKey
        case .longHistory:
            print ("\(apiPrefix)\(ticker)outputsize=full\(apiKeySegment)\(apiKey)")
            return apiPrefix + ticker + "&outputsize=full" + apiKeySegment + apiKey
            
        }
        
    }
    
}
