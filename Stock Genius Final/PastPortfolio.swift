//
//  PastPortfolio.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPortfolio: NSObject {
    
    var startDate : Date
    var endDate : Date
    var name : String
    var rank : Int
    var holdings : [PastStock]
    var index : PastStock
    
    
    override init() {
        self.startDate = Date()
        self.endDate = Date()
        self.name = ""
        self.rank = 0
        self.holdings = []
        self.index = PastStock()
        super.init()
    }
    
    public func averageReturn() -> Float {
        var totalReturn : Float = 0
        for holding in holdings {
            totalReturn = totalReturn + holding.finalPercentageReturn
        }
        return holdings.count == 0 ? 0.0 : totalReturn
    }
    
    public func averageReturnString() -> String {
        return String(format: "%.1f", averageReturn())
    }
    
    public func stockGeniusPlusMinus() -> Float {
        return averageReturn() - index.finalPercentageReturn
    }
    
    public func stockGeniusPlusMinusString() -> String {
        return String(format: "%.1f", stockGeniusPlusMinus() * 100)
    }
    
    public func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        return formatter.string(from:date)
        
    }
    
    
    
    
    

}
