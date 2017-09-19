//
//  SGConstants.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/18/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import UIKit

struct SGConstants {
    
    static let mainBlueColor : UIColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1)
    static let mainGreenColor : UIColor = UIColor.green
    static let mainRedColor : UIColor = UIColor.red
    static let offBlackColor: UIColor = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1)
    let formatter = NumberFormatter()
    
    public static func percentageChangeStringFrom(_ change: Float) -> String {
        let isPostive = change > 0
        let percentage = change * 100
        return isPostive ? "+" + String(format: "%.2f", percentage) + "%" : String(format: "%.2f", percentage) + "%"
    } 
    
    public static func priceChangeStringWithSignFrom(_ change: Float) -> String {
        let isPositive = change > 0
        return isPositive ? "+" + String(format:"%.2f", change) : String(format:"%.2f", change)
    }
    
    public static func priceChangeStringNoSignFrom(_ change: Float) -> String {
        let isPositive = change > 0
        return isPositive ? String(format:"%.2f", change) : String(format:"%.2f", -change)
    }
    
    public static func priceChangeStringNoSignFrom(beginPrice: Float, endPrice: Float) -> String {
        let change = endPrice - beginPrice
        return priceChangeStringNoSignFrom(change)
    }
    
    public static func percentageChangeStringFrom(beginPrice: Float, endPrice: Float) -> String {
        
        if beginPrice == 0 {
            return "-"
        } else {
            let change = (endPrice / beginPrice) - 1
            return SGConstants.percentageChangeStringFrom(change)
        }
    }
}
