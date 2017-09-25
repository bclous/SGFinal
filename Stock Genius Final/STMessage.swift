//
//  STMessage.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum STSentiment {
    case bullish
    case bearish
}

class STMessage: NSObject {
    
    let id : Int
    let body : String
    let dateCreated : Date
    let user : STUser
    let sentiment : STSentiment?
    let links : [STLink]?
    let image : STImage?
    
    init(id: Int, body: String, dateCreated: Date, user: STUser, sentiment: STSentiment?, links: [STLink]?, image: STImage?) {
        self.id = id
        self.body = body
        self.dateCreated = dateCreated
        self.user = user
        self.sentiment = sentiment
        self.links = links
        self.image = image
    }
    
    convenience init(response: [String : Any]) {
        
        let id = response["id"] as? Int ?? 0
        let body = response["body"] as? String ?? ""
        let dateCreatedString = response["created_at"] as? String ?? ""
        let dateCreated = Date.isoDateFromString(dateCreatedString) ?? Date()
        
        let userResponse = response["user"] as? [String: Any] ?? [:]
        let user = STMessage.userFromUserResponse(userResponse)
    
        let linksDictionary = response["links"] as? [[String : Any]]
        let links = STMessage.linksFromLinkResponse(linksDictionary)

        let entitiesDictionary = response["entities"] as? [String: Any]
        let imageDictionary = entitiesDictionary?["chart"] as? [String : String]
        let image = STMessage.imageFromChartResponse(imageDictionary)
        let sentimentDictionary = entitiesDictionary?["sentiment"] as? [String : Any]
        let sentiment = STMessage.sentimentFromSentimentResponse(sentimentDictionary)
        
        self.init(id: id, body: body, dateCreated: dateCreated, user: user, sentiment: sentiment, links: links, image: image)

    }
    
    public func primaryImageAddress() -> String? {
        
        if let image = image {
            return image.thumb
        } else if let links = links {
            return links[0].url
        } else {
            return nil
        }
    }
    
    public func highResImageAddress() -> String? {
        
        if let image = image {
            return image.large
        } else if let links = links {
            return links[0].url
        } else {
            return nil
        }
    }
    
    private static func linksFromLinkResponse(_ response: [[String : Any]]?) -> [STLink]? {
        
        var links: [STLink]?
        if let response = response {
            for link in response {
                let thisLink = STLink(linksResponse: link)
                links?.append(thisLink)
            }
        }
        return links
    }
    
    private static func imageFromChartResponse(_ response: [String : String]?) -> STImage? {

        var image : STImage?
        if let response = response {
            image = STImage(chartResponse: response)
        }
        return image
    }
    
    private static func sentimentFromSentimentResponse(_ response: [String : Any]?) -> STSentiment? {
        
        var sentiment : STSentiment?
        let sentimentString = response?["basic"] as? String ?? ""
        if sentimentString == "Bullish" {
            sentiment = .bullish
        } else if sentimentString == "Bearish" {
            sentiment = .bearish
        }
        
        return sentiment
    }
    
    private static func userFromUserResponse(_ response: [String : Any]) -> STUser {
        
        let id = response["id"] as? Int ?? 0
        let userFromDatabase = DataStore.shared.currentPortfolio.stockTwitsUserFromUserID(id)
        if let user = userFromDatabase {
            return user
        } else {
            let user = STUser(userResponse: response)
            DataStore.shared.currentPortfolio.addStockTwitsUserToDatabase(user)
            return user
        }
        
    }
    
    
    
    
    


}