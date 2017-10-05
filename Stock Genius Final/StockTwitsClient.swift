//
//  StockTwitsClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import Alamofire

class StockTwitsClient {
    
    static let trendingURL = "https://api.stocktwits.com/api/2/trending/symbols.json"
    static let symbolURLPrefix = "https://api.stocktwits.com/api/2/streams/symbol/"
    
    public static func pullTrendingSymbols(completionHandler: @escaping (_ success: Bool) -> ()) {
        
        let request = Alamofire.request(trendingURL)
        request.responseJSON { (response) in
            
            if response.result.isFailure {
                completionHandler(false)
            } else {
                let responseDictionary = response.value as? [String : Any]
                let reponseArray = responseDictionary?["symbols"] as? [[String : Any]]
                if let responseArray = reponseArray {
                   DataStore.shared.watchlistPortfolio.updateTrendingStocksFromResponse(responseArray)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    public static func pullMessagesForStock(_ stock: CurrentStock, completionHandler: @escaping(_ success: Bool) -> ()) {
        
        let requestURL = symbolURLPrefix + stock.ticker + ".json"
        let request = Alamofire.request(requestURL)
        request.responseJSON { (response) in
            
            if response.result.isFailure {
                completionHandler(false)
            } else {
                let responseDictionary = response.value as? [String : Any] ?? [:]
                if responseDictionary.isEmpty {
                    completionHandler(false)
                } else {
                    stock.updateStockTwitsMessagesFromResponse(responseDictionary)
                    completionHandler(true)
                }
            }
        }
    }
    
}

