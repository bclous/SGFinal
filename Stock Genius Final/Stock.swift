//
//  Stock.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class Stock: NSObject {
    
    var ticker : String
    var companyName : String
    var note : String
    var rankInPortfolio : Int
    var yahooURL : String
    var newsItems : [NewsItem]
    
    override init() {
        self.ticker = ""
        self.companyName = ""
        self.note = ""
        self.rankInPortfolio = 0
        self.yahooURL = ""
        self.newsItems = []
        super.init()
    }
    
    public func priceString(_ price: Float) -> String {
        return String(format: "%.2f", price)
    }
    
    public func percentageString(startPx: Float, endPx : Float) -> String {
        return startPx == 0 ? "-" : percentageStringFromDecimal(endPx / startPx - 1) + "%"
    }
    
    public func percentageStringFromDecimal( _ change: Float) -> String {
        return String(format: "%.1f", abs(change * 100))
    }
    
    public func dollarChangeImage(startPx: Float, endPx: Float) -> UIImage? {
        return endPx >= startPx ? UIImage(named: "upImage") : UIImage(named: "downImage")
    }
    
    
    

}
    