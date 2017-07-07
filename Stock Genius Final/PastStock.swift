//
//  PastStock.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastStock: Stock {
    
    var adjPriceStartDate : Float
    var adjPriceEndDate : Float
    var finalPercentageReturn : Float
    
    override init() {
        self.adjPriceStartDate = 0
        self.adjPriceEndDate = 0
        self.finalPercentageReturn = 0
        super.init()
    }
    
    public func percentageChangeString() -> String {
        return String(format: "%.1f", finalPercentageReturn * 100)
    }
    
    public func updatePastStockValues(dictionary: Dictionary<String, Any>) {
        companyName = dictionary["name"] as? String ?? ""
        ticker = dictionary["ticker"] as? String ?? ""
        adjPriceStartDate = dictionary["startPx"] as? Float ?? 0
        adjPriceEndDate = dictionary["endPx"] as? Float ?? 0
        finalPercentageReturn = adjPriceEndDate == 0 ? 0 : 1 - (adjPriceEndDate / adjPriceStartDate)
        rankInPortfolio = dictionary["rank"] as? Int ?? 99
    }
    

}
