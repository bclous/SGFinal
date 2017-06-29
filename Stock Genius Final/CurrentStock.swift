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
    
    override init() {
        self.adjPriceCurrent = 0
        self.adjPriceStartDate = 0
        self.adjPriceLastClose = 0
        super.init()
    }
    
    public func percentageReturn(isTodayReturn: Bool) -> Float {
        if isTodayReturn {
            return adjPriceLastClose == 0 ? 0 : adjPriceCurrent / adjPriceLastClose
        } else {
            return adjPriceStartDate == 0 ? 0 : adjPriceCurrent / adjPriceStartDate
        }
    }
    

    

}
