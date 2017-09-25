//
//  STLink.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class STLink: NSObject {
    
    let title : String?
    let url : String
    let shortenedURL : String
    let shortenedExpandedURL : String
    let summary : String?
    let imageURL : String?
    let dateCreated : Date
    let videoURL : String?
    let source : String?
    
    init(title: String?, url: String, shortenedURL: String, shortenedExpandedURL: String, summary: String?, imageURL: String?, dateCreated: Date, videoURL: String?, source: String?) {
        
        self.title = title
        self.url = url
        self.shortenedURL = shortenedURL
        self.shortenedExpandedURL = shortenedExpandedURL
        self.summary = summary
        self.imageURL = imageURL
        self.dateCreated = dateCreated
        self.videoURL = videoURL
        self.source = source
    }
    
    convenience init(linksResponse: [String : Any]) {
        
        let title = linksResponse["title"] as? String
        let url = linksResponse["url"] as? String ?? ""
        let shortenedURL = linksResponse["shortened_url"] as? String ?? ""
        let shortenedExpandedURL = linksResponse["shortened_expanded_url"] as? String ?? ""
        let summary = linksResponse["description"] as? String
        let imageURL = linksResponse["image"] as? String
        let dateCreatedISOString = linksResponse["created_at"] as? String ?? ""
        let dateCreated = Date.isoDateFromString(dateCreatedISOString) ?? Date()
        let videoURL = linksResponse["video_url"] as? String
        let sourceDictionary = linksResponse["source"] as? [String: String]
        let source = sourceDictionary?["name"]
        
        print("\(imageURL)")
        
        self.init(title: title, url: url, shortenedURL: shortenedURL, shortenedExpandedURL: shortenedExpandedURL, summary: summary, imageURL: imageURL, dateCreated: dateCreated, videoURL: videoURL, source: source)
    }

}
