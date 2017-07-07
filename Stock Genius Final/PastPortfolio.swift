//
//  PastPortfolio.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPortfolio: NSObject {
    
    var startDate : String
    var endDate : String
    var name : String
    var rank : Int
    var holdings : [PastStock]
    var index : PastStock
    var note : String
    
    
    override init() {
        self.startDate = ""
        self.endDate = ""
        self.name = ""
        self.rank = 0
        self.holdings = []
        self.index = PastStock()
        self.note = ""
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
    
    public func updatePastPortfolioValues(dictionary: Dictionary<String, Any>) {
        name = dictionary["name"] as? String ?? ""
        startDate = dictionary["startDate"] as? String ?? ""
        endDate = dictionary["endDate"] as? String ?? ""
        note = dictionary["note"] as? String ?? ""
        
        let holdingsDictionary = dictionary["holdings"] as? Dictionary<String, Any>
        if holdingsDictionary != nil {
            
            let keys = holdingsDictionary!.keys
            for key in keys {
                let pastStockDictionary = holdingsDictionary![key] as! Dictionary<String, Any>
                if key == "index" {
                    index.updatePastStockValues(dictionary: pastStockDictionary)
                } else {
                    let newPastStock = PastStock()
                    newPastStock.updatePastStockValues(dictionary: pastStockDictionary)
                    holdings.append(newPastStock)
                }
                
            }
            
            holdings.sort(by: {$0.rankInPortfolio < $1.rankInPortfolio})
            
        }
    }
    
}
