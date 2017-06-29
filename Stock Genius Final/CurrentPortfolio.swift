//
//  CurrentPortfolio.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentPortfolio: NSObject {
    
    var startDate : Date
    var endDate : Date
    var name : String
    var note : String
    var holdings : [CurrentStock]
    var index : CurrentStock
    
    override init() {
        self.startDate = Date()
        self.endDate = Date()
        self.name = ""
        self.note = ""
        self.holdings = []
        self.index = CurrentStock()
        super.init()
    }
    
    public func averageReturn(isTodayReturn: Bool) -> Float {
        var totalReturn : Float = 0
        for holding in holdings {
            if holding.rankInPortfolio <= 10 {
                totalReturn = totalReturn + holding.percentageReturn(isTodayReturn: isTodayReturn)
            }
        }
        return holdings.count == 0 ? 0.0 : totalReturn
    }
    
    public func averageReturnString(isTodayReturn: Bool) -> String {
        return String(format: "%.1f", averageReturn(isTodayReturn: isTodayReturn))
    }
    
    public func stockGeniusPlusMinus(isTodayReturn: Bool) -> Float {
        let indexReturn = index.percentageReturn(isTodayReturn: isTodayReturn)
        let avgReturn = averageReturn(isTodayReturn: isTodayReturn)
        return avgReturn - indexReturn
    }
    
    public func stockGeniusPlusMinusString(isTodayReturn: Bool) ->String {
        let difference = stockGeniusPlusMinus(isTodayReturn: isTodayReturn)
        return String(format: "%.1f", difference)
    }
    
    public func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        return formatter.string(from:date)
        
    }
    

    
    
    
    
    
    

}
