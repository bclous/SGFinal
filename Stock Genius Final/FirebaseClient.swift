//
//  FirebaseClient.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage


class FirebaseClient: NSObject {
    
    static let shared = FirebaseClient()
    var ref : DatabaseReference
        
    private override init() {
        ref = Database.database().reference()
        super.init()
    }
    
    func performInitialDatabasePull(completion: @escaping (_ success: Bool, _ response: [String : Any]) -> ()) {
        
        ref.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            let responseDictionary = dataSnapshot.value as? [String : Any]
            if let responseDictionary = responseDictionary {
                completion(true, responseDictionary)
            } else {
                completion(false, [:])
            }
        })
    }
    
    func downloadImagesFromStorage(completion: @escaping (_ success: Bool) -> ()) {
        
        let storage = Storage.storage()
        let folderRef = storage.reference()
        var stickersDownloaded = 0
        
        for index in 0...DataStore.shared.imageNames.count - 1
        {
            let fileName = "\(DataStore.shared.imageNames[index]).png"
            let fileReference = folderRef.child(fileName)
            let optionalLocalURL = DataStore.shared.localURLFromFileName(DataStore.shared.imageNames[index])
            
            if let localURL = optionalLocalURL {
                fileReference.write(toFile: localURL)
                { (url, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        stickersDownloaded += 1
                        if stickersDownloaded == DataStore.shared.imageNames.count
                        {
                            completion(true)
                        }
                    }
                }
            }
        }
    }

}
