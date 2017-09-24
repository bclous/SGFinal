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
                   // addStocksToStoreFromResponse(responseArray)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    public static func pullMessagesForSymbol(_ symbol: String, completionHandler: @escaping(_ success: Bool) -> ()) {
        
        let requestURL = symbolURLPrefix + symbol + ".json"
        let request = Alamofire.request(requestURL)
        request.responseJSON { (response) in
            
            if response.result.isFailure {
                completionHandler(false)
            } else {
                let responseDictionary = response.value as? [String : Any]
                let responseArray = responseDictionary?["messages"] as? [[String : Any]]
               // let stock = DataStore.shared.stockFromSymbol(symbol)
                if let stock = stock, let responseArray = responseArray {
                    addMessagesToStock(stock, responseArray: responseArray)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
//    
//    private static func addStocksToStoreFromResponse(_ responseArray: [[String : Any]]) {
//        
//        DataStore.shared.emptyTrendingStocks()
//        for stockDataResponse in responseArray {
//            let stock = Stock(response: stockDataResponse)
//            DataStore.shared.trendingStocks.append(stock)
//        }
//    }
//    
//    private static func addMessagesToStock(_ stock: Stock, responseArray: [[String : Any]]) {
//        
//        stock.clearAllMessages()
//        for messageResponse in responseArray {
//            let message = Message(messageResponse: messageResponse)
//            stock.messages.append(message)
//            let user = message.user
//            if !DataStore.shared.isUserInDatabase(userID: user.id) {
//                DataStore.shared.users.append(user)
//            }
//        }
//        stock.sortMessages(reverseChrono: true)
//    }
}

