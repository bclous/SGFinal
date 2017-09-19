//
//  FBClient.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/12/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

protocol FBClientDelegate: class {
    func firebasePullComplete(success: Bool)
}

class FBClient {
    
    static let shared = FBClient()
    weak var delegate : FBClientDelegate?
    
      func initialFireBasePull() {
        
        let databaseRef = Database.database().reference()
        let appInfoRef = databaseRef.child("appInfo")
        
        appInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let appInfoDictionary = snapshot.value as! Dictionary<String, Any>
            let noUpdateNeeded = self.matchesDefaults(dictionary: appInfoDictionary)
            
            if noUpdateNeeded {
                CDClient.updateNewsItems(dictionary: appInfoDictionary)
                self.delegate?.firebasePullComplete(success: true)
            } else {
               self.portfoliosFirebasePull(appInfo: appInfoDictionary)
            }
            
        }) { (error) in
            self.delegate?.firebasePullComplete(success: false)
        }
    }
    
    func matchesDefaults(dictionary: Dictionary<String, Any>) -> Bool {
        
        let key = dictionary["lastUpdateKey"] as! String
        
        if UserDefaults.standard.object(forKey: "lastUpdateKey") == nil {
            updateDefaults(key: key)
            return false
        } else {
            let match = dictionary["lastUpdateKey"] as! String == UserDefaults.standard.object(forKey: "lastUpdateKey") as! String
            if match {
                return true
            } else {
                updateDefaults(key: key)
                return false
            }
        }
    }
    
    func updateDefaults(key: String) {
        UserDefaults.standard.set(key, forKey: "lastUpdateKey")
    }
    
    func updateDefaults(from dictionary: NSDictionary) {
        let key = dictionary.object(forKey: "lastUpdateKey") as! String
        UserDefaults.standard.set(key, forKey: "lastUpdateKey")
    }
    
    func portfoliosFirebasePull(appInfo: Dictionary<String, Any>) {
        
        let databaseRef = Database.database().reference()
    
        databaseRef.observe(.value, with: { (snapshot) in
            
            let fullDictionary = snapshot.value as! Dictionary<String, Any>
            CDClient.updatePortfolios(dictionary: fullDictionary)
            CDClient.updateNewsItems(dictionary: appInfo)
            self.delegate?.firebasePullComplete(success: true)
            
        }) { (error) in
            self.delegate?.firebasePullComplete(success: false)
        }
    }

}
