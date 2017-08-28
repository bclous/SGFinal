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
    var articles : [Article]
    var priceHistory : [Date : Float]
    var hasShortPriceHistory : Bool
    var hasLongPriceHistory : Bool
    var hasPicturesSaved : Bool
    
    override init() {
        self.isTrading = true
        self.adjPriceCurrent = 0
        self.adjPriceStartDate = 0
        self.adjPriceLastClose = 0
        self.acquiredPrice = 0
        self.startingPriceHardCode = 0
        self.articles = []
        self.priceHistory = [:]
        self.hasShortPriceHistory = false
        self.hasLongPriceHistory = false
        self.hasPicturesSaved = false
        super.init()
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
    
    public func updateCurrentStockValues(dictionary: Dictionary<String, Any>) {
        isTrading = dictionary["isTrading"] as? Bool ?? true
        companyName = dictionary["name"] as? String ?? ""
        note = dictionary["note"] as? String ?? ""
        rankInPortfolio = dictionary["rank"] as? Int ?? 99
        ticker = dictionary["ticker"] as? String ?? ""
        acquiredPrice = dictionary["acquiredPrice"] as? Float ?? 0.0
        startingPriceHardCode = dictionary["startingPriceHardCode"] as? Float ?? 0.0
        
        
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

}
