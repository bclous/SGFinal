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
    var lowResImage : UIImage?
    var highResImage : UIImage?
    
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
    
    public func firstLinkAddress() -> String? {
        if let links = self.links {
            return links[0].url
        } else {
            return nil
        }
    }
    
    public func primaryImageAddress() -> String? {
        
        if let image = image {
            return image.url
        } else if let links = links {
            return links[0].imageURL
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
    
    public func finalMessageString() -> NSAttributedString {
        
        if let links = self.links {
            let firstLink = links[0]
            let longURL = firstLink.url
            let shortURL = firstLink.shortenedExpandedURL
            let newBody = body.replacingOccurrences(of: longURL, with: shortURL)
            
            let range = (newBody as NSString).range(of: shortURL)
            let attributedBody = NSMutableAttributedString(string: newBody)
            attributedBody.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range)
            attributedBody.addAttribute(NSUnderlineColorAttributeName, value: SGConstants.mainBlueColor, range: range)
            attributedBody.addAttribute(NSForegroundColorAttributeName, value: SGConstants.mainBlueColor, range: range)
      
            return attributedBody
        } else {
            return NSAttributedString(string: body)
        }
        
    }
    
    private static func linksFromLinkResponse(_ response: [[String : Any]]?) -> [STLink]? {
        
        var messageLinks: [STLink] = []
        if let response = response {
            for link in response {
                let thisLink = STLink(linksResponse: link)
                messageLinks.append(thisLink)
            }
            return messageLinks
        } else {
            return nil
        }
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
    
    public func cacheMessageImage(_ image: UIImage, isLowRes: Bool) {
        do {
            let pathComponent = isLowRes ? "\(id)-lowRes.png" : "\(id)-highRes.png"
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(pathComponent)
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch { }
    }
    
    public func messageImage(isLowRes: Bool) -> UIImage? {
        let pathComponent = isLowRes ? "\(id)-lowRes.png" : "\(id)-highRes.png"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(pathComponent).path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        
        return nil
    }
    

    
    
    
    
    


}
