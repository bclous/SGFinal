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


protocol FirebaseClientDelegate: class {
    func fireBasePullComplete(success: Bool)
    func imagePullComplete(success: Bool)
    
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
    
    func performIntroScreenImagePull() {
        downloadFromStorage()
    }
    
    
    func downloadFromStorage() {
        
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
                        self.delegate?.imagePullComplete(success: false)
                    }
                    else
                    {
                        stickersDownloaded += 1
                        print("\(DataStore.shared.imageNames[index]) we got \(stickersDownloaded) out of \(DataStore.shared.imageNames.count)")
                        
                        if stickersDownloaded == DataStore.shared.imageNames.count
                        {
                            self.delegate?.imagePullComplete(success: true)
                        }
                    }
                }
            }
        }
    }

}
