//
//  Article.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/28/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation

struct Article {
    
    var articleURL : String
    var pictureURL : String
    var headline : String
    var rank : Int
    
    init(articleURL: String, pictureURL: String, headline: String, rank: Int) {
        self.articleURL = articleURL
        self.pictureURL = pictureURL
        self.headline = headline
        self.rank = rank
    }
    
}
