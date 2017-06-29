//
//  NewsItem.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class NewsItem: NSObject {
    
    var articleURL : String
    var headline : String
    var pictureName : String
    var rank : Int
    
    override init() {
        self.articleURL = ""
        self.headline = ""
        self.pictureName = ""
        self.rank = 0
        super.init()
    }

}
