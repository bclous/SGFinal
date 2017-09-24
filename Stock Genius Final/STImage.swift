//
//  STImage.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class STImage: NSObject {
    
    let thumb : String
    let large : String
    let original : String
    let url: String
    
    
    init(thumb: String, large: String, original: String, url: String) {
        self.thumb = thumb
        self.large = large
        self.original = original
        self.url = url
    }
    
    convenience init(chartResponse: [String : String]) {
        let thumb = chartResponse["thumb"] ?? ""
        let large = chartResponse["large"] ?? ""
        let original = chartResponse["original"] ?? ""
        let url = chartResponse["url"] ?? ""
        self.init(thumb: thumb, large: large, original: original, url: url)
    }

}
