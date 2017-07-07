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
    
    override init() {
        self.isTrading = true
        self.adjPriceCurrent = 0
        self.adjPriceStartDate = 0
        self.adjPriceLastClose = 0
        super.init()
    }
    
    public func percentageReturn(isTodayReturn: Bool) -> Float {
        if isTodayReturn {
            return adjPriceLastClose == 0 ? 0 : adjPriceCurrent / adjPriceLastClose - 1
        } else {
            return adjPriceStartDate == 0 ? 0 : adjPriceCurrent / adjPriceStartDate - 1
        }
    }
    
    public func updateCurrentStockValues(dictionary: Dictionary<String, Any>) {
        isTrading = dictionary["isTrading"] as? Bool ?? true
        companyName = dictionary["name"] as? String ?? ""
        note = dictionary["note"] as? String ?? ""
        rankInPortfolio = dictionary["rank"] as? Int ?? 99
        ticker = dictionary["ticker"] as? String ?? ""
    }
    
    public func startDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: dateString)
        return date
    }

}
