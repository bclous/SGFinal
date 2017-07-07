//
//  FirebaseClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol FirebaseClientDelegate: class {
    func fireBasePullComplete(success: Bool)
}

class FirebaseClient: NSObject {
    
    static let shared = FirebaseClient()
    var ref : DatabaseReference
    weak var delegate : FirebaseClientDelegate?
    
    private override init() {
        ref = Database.database().reference()
        super.init()
    }
    
    func performInitialDatabasePull() {
        
        ref.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            let fullDictionary = dataSnapshot.value as? Dictionary<String, Any>
            if fullDictionary != nil {
                DataStore.shared.populateAppWithData(dictionary: fullDictionary!)
                self.delegate?.fireBasePullComplete(success: true)
            } else {
                self.delegate?.fireBasePullComplete(success: false)
            }
        })
        
    }

}
