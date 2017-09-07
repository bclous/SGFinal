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
    
    let apiPrefix = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol="
    let apiKeySegment = "&apikey="
    var apiKey = "5875"
    

    
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
        let requestURL = urlStringForStock(stock, isLongPull: false)
        let request = Alamofire.request(requestURL)
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        
        request.response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
            
            let responseDictionary = response.value as? [String : Any]
            let isGoodResponse = !response.result.isFailure && responseDictionary?.count ?? 0 > 0 && responseDictionary != nil
            
            if isGoodResponse {
                stock.updatePricesWithResponse(responseDictionary!)
                completion(true)
            } else {
                completion(false)
                print("failed for: \(stock.ticker)")
            }
        }
    }
    
    private func urlStringForStock(_ stock: CurrentStock, isLongPull: Bool) -> String {
        let ticker = stock.ticker
        return apiPrefix + ticker + apiKeySegment + apiKey
    }
    
}
