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
    

}
