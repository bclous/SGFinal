//
//  DataStore.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol DataStoreDelegate: class {
    func firebasePullComplete(success: Bool)
    func pricePullComplete(success: Bool)
    func pricePullInProgress(percentageComplete: Float)
}

class DataStore: NSObject, AlphaVantageClientDelegate, FirebaseClientDelegate {
    
    static let shared = DataStore()
    var currentPortfolio : CurrentPortfolio
    var pastPortfolios : [PastPortfolio]
    var ref : DatabaseReference
    weak var delegate : DataStoreDelegate?
    var pricePullComplete = false
    var firebasePullComplete = false
    var APIKey = "5875"
    
    private override init() {
        self.currentPortfolio = CurrentPortfolio()
        self.pastPortfolios = []
        self.ref = Database.database().reference()
        super.init()
        FirebaseClient.shared.performInitialDatabasePull()
        FirebaseClient.shared.delegate = self
        AlphaVantageClient.shared.delegate = self
    }
    
    func pricePullComplete(success: Bool) {
        delegate?.pricePullComplete(success: success)
    }
    
    func fireBasePullComplete(success: Bool) {
        delegate?.firebasePullComplete(success: success)
    }
    
    public func populateAppWithData(dictionary: Dictionary<String, Any>) {
        let currentPortfolioDictionary = dictionary["currentPortfolio"] as? Dictionary<String, Any>
        let pastPortfoliosDictionary = dictionary["pastPortfolios"] as? Dictionary<String, Any>
        let appInfo = dictionary["appInfo"] as? Dictionary<String, Any>
        
        if currentPortfolioDictionary != nil && pastPortfoliosDictionary != nil && appInfo != nil {
            populateCurrentPortfolio(dictionary: currentPortfolioDictionary!)
            populatePastPortfolios(dictionary: pastPortfoliosDictionary!)
            populateAppWithData(dictionary: appInfo!)
          
            
            AlphaVantageClient.shared.updatePricesForCurrentPortfolio()
            
        } else {
            // send out fail
        }

    }
    
    public func pastPortfoliosString() -> String {
        
        if pastPortfolios.count == 0 {
            return "no data"
        } else {
            let startString = pastPortfolios[0].startDateString()
            let endDateString = pastPortfolios.last?.endDateString()
            
            return startString + " - " + endDateString! + " (\(pastPortfolios.count) quarters)"
        }
    }
    
    
    // private helper methods
    
    private func populateCurrentPortfolio(dictionary: Dictionary<String, Any>) {
        currentPortfolio.updateCurrentPortfolioValues(dictionary: dictionary)
    }
    
    private func populatePastPortfolios(dictionary: Dictionary<String, Any>) {
        
        let keys = dictionary.keys
        
        for key in keys {
            let pastPortfolioDictionary = dictionary[key] as? Dictionary<String, Any>
            if pastPortfolioDictionary != nil {
                let pastPortfolio = PastPortfolio()
                pastPortfolio.updatePastPortfolioValues(dictionary: pastPortfolioDictionary!)
                pastPortfolios.append(pastPortfolio)
            }
        }
        
        sortPastPortfolios()
        
    }
    
    private func populateAppInfo(dictionary: Dictionary<String, Any>) {
        
    }
    
    private func sortPastPortfolios() {
        pastPortfolios.sort(by: {$0.rank > $1.rank})
    }
    
    

}
