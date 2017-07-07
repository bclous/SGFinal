//
//  CurrentPortfolio.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CurrentPortfolio: NSObject {
    
    var startDate : String
    var endDate : String
    var name : String
    var note : String
    var holdings : [CurrentStock]
    var index : CurrentStock
    
    override init() {
        self.startDate = ""
        self.endDate = ""
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
        return holdings.count == 0 ? 0.0 : totalReturn / 10.0
    }
    
    public func averageReturnString(isTodayReturn: Bool) -> String {
        return String(format: "%.1f", abs(averageReturn(isTodayReturn: isTodayReturn)) * 100) + "%"
    }
    
    public func stockGeniusPlusMinus(isTodayReturn: Bool) -> Float {
        let indexReturn = index.percentageReturn(isTodayReturn: isTodayReturn)
        let avgReturn = averageReturn(isTodayReturn: isTodayReturn)
        let roundedIndexReturn = (indexReturn * 1000).rounded() / 1000
        let roundedAvgReturn = (avgReturn * 1000).rounded() / 1000
        return roundedAvgReturn - roundedIndexReturn
    }
    
    public func stockGeniusPlusMinusString(isTodayReturn: Bool) ->String {
        let difference = stockGeniusPlusMinus(isTodayReturn: isTodayReturn)
        return String(format: "%.1f", abs(difference) * 100) + "%"
    }
    
    public func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        return formatter.string(from:date)
        
    }
    
    public func updateCurrentPortfolioValues(dictionary: Dictionary<String, Any>) {
        
        endDate = dictionary["endDate"] as? String ?? ""
        startDate = dictionary["startDate"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        
        let holdingsDictionary = dictionary["holdings"] as? Dictionary<String, Any>
        if holdingsDictionary != nil {
            let keys = holdingsDictionary!.keys
            for key in keys {
               
                    let newStockDictionary = holdingsDictionary![key] as? Dictionary<String, Any>
                    if newStockDictionary != nil {
                        
                        if key == "index" {
                            index.updateCurrentStockValues(dictionary: newStockDictionary!)
                        } else {
                            let newStock = CurrentStock()
                            newStock.updateCurrentStockValues(dictionary: newStockDictionary!)
                            self.holdings.append(newStock)
                        }
                    }
            }
            
            holdings.sort(by: {$0.rankInPortfolio < $1.rankInPortfolio})
        }
        
    }
    
    public func startDateString() -> String {
        return stringFromDateString(startDate) ?? startDate
    }
    
    public func endDateString() -> String? {
        if endDate == "" {
            return nil
        } else {
            return stringFromDateString(endDate)
        }
    }
    
    public func stringFromDateString(_ originalString: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: originalString)
        dateFormatter.dateFormat = "M.d.yyyy"
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return nil
        }

    }
}
