//
//  SymbolResult.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SymbolResult: NSObject {
    
    let ticker : String
    let name : String
    let isEnabled : Bool
    let type : String
    
    init(ticker: String, name: String, isEnabled: Bool, type: String) {
        self.ticker = ticker
        self.name = name
        self.isEnabled = isEnabled
        self.type = type
    }
    
    convenience init(response: [String : Any]) {
        let ticker = response["symbol"] as? String ?? ""
        let name = response["name"] as? String ?? ""
        let isEnabled = response["isEnabled"] as? Bool ?? false
        let type = response["type"] as? String ?? ""
        self.init(ticker: ticker, name: name, isEnabled: isEnabled, type: type)
    }

}
