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
    var date : Date
    var source : String
    var summary : String
    
    
    init(date: Date, url: String, headline: String, source: String, summary: String) {
        self.date = date
        self.articleURL = url
        self.headline = headline
        self.source = source
        self.summary = summary
    }
    
    convenience init(articleResponse: [String : String]) {
        let dateString = articleResponse["datetime"] ?? ""
        let articleDate = Date.isoDateFromString(dateString) ?? Date()
        let url = articleResponse["url"] ?? ""
        let headline = articleResponse["headline"] ?? ""
        let source = articleResponse["source"] ?? ""
        let summary = articleResponse["summary"] ?? ""

        self.init(date: articleDate, url: url, headline: headline, source: source, summary: summary)
    }
    
    


    

}
