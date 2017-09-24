//
//  STUser.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class STUser: NSObject {
    
    let id : String
    let userName : String
    let name : String
    let avatarURL : String
    let avatarSSLURL : String
    let joinDate : Date
    
    init(id: String, userName: String, name: String, avatarURL: String, avatarSSHURL: String, joinDate: Date) {
        self.id = id
        self.userName = userName
        self.name = name
        self.avatarURL = avatarURL
        self.avatarSSLURL = avatarSSHURL
        self.joinDate = joinDate
    }
    
    convenience init(userResponse: [String : Any]) {
        
        let id = userResponse["id"] as? String ?? ""
        let userName = userResponse["username"] as? String ?? ""
        let name = userResponse["name"] as? String ?? ""
        let avatarURL = userResponse["avatar_url"] as? String ?? ""
        let avatarSSLURL = userResponse["avatar_url_ssl"] as? String ?? ""
        let joinDateString = userResponse["join_date"] as? String ?? ""
        let joinDate = Date.dateFromString(joinDateString, dateFormat: "yyyy-MM-dd") ?? Date()
        
        self.init(id: id, userName: userName, name: name, avatarURL: avatarURL, avatarSSHURL: avatarSSLURL, joinDate: joinDate)
    }

}
