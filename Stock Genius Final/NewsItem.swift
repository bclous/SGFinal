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
        
        let adjustedSummary = summary.trimmingCharacters(in: .whitespaces)
        let finalSummary = adjustedSummary == "No summary available." ? "" : adjustedSummary

        self.init(date: articleDate, url: url, headline: headline, source: source, summary: finalSummary)
    }
    
    public func createdAtString() -> String? {
        
        let datesAreSameDay = Date.datesAreSameDay(date1: Date(), date2: date)
        if datesAreSameDay {
            let seconds = Int(Date().timeIntervalSince(date))
            
            if seconds < 60 {
                return String(seconds) + "s"
            } else if seconds < 3600 {
                return String(seconds/60) + "m"
            } else {
                return date.string(withFormat: "h:mm a")
            }
        } else {
            return date.string(withFormat: "M/d/yyyy, h:mm a")
        }
    }

    
    


    

}
