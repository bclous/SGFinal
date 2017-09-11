//
//  StockPriceDay.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation

struct StockPriceDay {
    
    let date : Date
    var open : Float
    var high : Float
    var low : Float
    var close : Float
    var adjustedClose : Float
    var volume : Int
    var dividendAmount : Float
    var splitCoefficient : Float
    
    
    init(date: Date, open: Float, high: Float, low: Float, close: Float, adjustedClose: Float, volume: Int, dividendAmount : Float, splitCoefficient: Float) {
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.adjustedClose = adjustedClose
        self.volume = volume
        self.dividendAmount = dividendAmount
        self.splitCoefficient = splitCoefficient
    }
    
    init(dateKey: String, responseValue: [String : String]) {
        
        let dateString = dateKey
        let date = Date.dateFromString(dateString, dateFormat: "yyyy-MM-dd") ?? Date()
        let openString = responseValue["1. open"] ?? "0"
        let highString = responseValue["2. high"] ?? "0"
        let lowString = responseValue["3. low"] ?? "0"
        let closeString = responseValue["4. close"] ?? "0"
        let adjustedCloseString = responseValue["5. adjusted close"] ?? "0"
        let volumeString = responseValue["6. volume"]  ?? "0"
        let dividendAmountString = responseValue["7. divident amount"] ?? "0"
        let splitCoefficientString = responseValue["8. split coefficient"] ?? "0"
        
        let open : Float = Float(openString) ?? 0
        let high : Float = Float(highString) ?? 0
        let low : Float = Float(lowString) ?? 0
        let close : Float = Float(closeString) ?? 0
        let adjustedClose : Float = Float(adjustedCloseString) ?? 0
        let volume : Int = Int(volumeString) ?? 0
        let dividendAmount : Float = Float(dividendAmountString) ?? 0
        let splitCoefficient : Float = Float(splitCoefficientString) ?? 0
        
        self.init(date: date, open: open, high: high, low: low, close: close, adjustedClose: adjustedClose, volume: volume, dividendAmount: dividendAmount, splitCoefficient: splitCoefficient)
    }
    
}
