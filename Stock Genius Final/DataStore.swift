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
    func pricePullInProgress(percentageComplete: Float)
}

class DataStore: NSObject, AlphaVantageClientDelegate {
    
    static let shared = DataStore()
    var currentPortfolio : CurrentPortfolio
    var pastPortfolios : [PastPortfolio]
    var ref : DatabaseReference
    weak var delegate : DataStoreDelegate?
    var pricePullComplete = false
    var firebasePullComplete = false
    var APIKey = "5875"
    var totalIndexPerformance : Float
    var totalStockGeniusPerformance : Float
    var imageNames = ["page1Background", "girl", "mainPage1", "mainPage2", "mainPage3", "mainPage4", "mainPage5", "mainPage6","graphicPage1", "graphicPage2", "otherBackground"]
    var individualToggleState : IndividualSegmentType = .sinceStartDate
    let currentPricesKey = "currentPortfolioPrices"
    let startDateKey = "currentPortfolioStartDate"

    
    private override init() {
        self.currentPortfolio = CurrentPortfolio()
        self.pastPortfolios = []
        self.ref = Database.database().reference()
        self.totalIndexPerformance = 300
        self.totalStockGeniusPerformance = 200
        super.init()
        AlphaVantageClient.shared.delegate = self
    }
    
    public func performInitialFirebasePull(completion: @escaping(_ success: Bool) -> ()) {
        
        FirebaseClient.shared.performInitialDatabasePull { (success, result) in
            if success {
                let result = self.populateAppWithData(dictionary: result)
                completion(result)
            } else {
                completion(false)
            }
        }
    }
    
    public func performUpdatePricesPull(completion: @escaping(_ success: Bool) -> ()) {
        AlphaVantageClient.shared.updatePricesForCurrentPortfolio { (success) in
            if success {
                self.currentPortfolio.cachePrices()
            }
            completion(success)
        }
    }
    
    public func appNeedsFullUpdateOnSplashScreen() -> Bool {
        
        let cachedCurrentPortfolioStartDate = UserDefaults.standard.object(forKey: startDateKey) as? String ?? ""
        if cachedCurrentPortfolioStartDate != currentPortfolio.startDate {
            UserDefaults.standard.set(currentPortfolio.startDate, forKey: startDateKey)
            return true
        } else {
            return !priceCacheExists()
        }
    }
    
    public func pricePullInProgressFromAV(percentageComplete: Float) {
        delegate?.pricePullInProgress(percentageComplete: percentageComplete)
    }
    
    public func priceCacheExists() -> Bool {
        if UserDefaults.standard.object(forKey: currentPricesKey) != nil {
            return true
        } else {
            return false
        }
    }
    
    
    public func pastPortfoliosString() -> String {
        
        if pastPortfolios.count == 0 {
            return "no data"
        } else {
            let startString = pastPortfolios.last?.startDateString()
            let endDateString = pastPortfolios[0].endDateString()
            
            return startString! + " - " + endDateString + " (\(pastPortfolios.count) quarters)"
        }
    }
    
    
    
    
    // private helper methods
    
    private func populateAppWithData(dictionary: [String : Any]) -> Bool {
        let currentPortfolioDictionary = dictionary["currentPortfolio"] as? Dictionary<String, Any>
        let pastPortfoliosDictionary = dictionary["pastPortfolios"] as? Dictionary<String, Any>
        let appInfo = dictionary["appInfo"] as? Dictionary<String, Any>
        let performance = dictionary["performance"] as? Dictionary<String, Float>
        let articles = dictionary["articles"] as? [String : Any]
        
        if currentPortfolioDictionary != nil && pastPortfoliosDictionary != nil && appInfo != nil && articles != nil {
            populateCurrentPortfolio(dictionary: currentPortfolioDictionary!)
            populatePastPortfolios(dictionary: pastPortfoliosDictionary!)
            populateAppInfo(dictionary: appInfo!)
            populatePerformanceData(dictionary: performance!)
            
            return true

        } else {
            return false
        }
        
    }
    
    private func populateAppInfo(dictionary: [String : Any]) {
        let apiKey = dictionary["alphaVantageAPIKey"] as? String
        if let apiKey = apiKey {
            self.APIKey = apiKey
            AlphaVantageClient.shared.apiKey = apiKey
        }
    }
    
    private func populateCurrentPortfolio(dictionary: Dictionary<String, Any>) {

        currentPortfolio.updateCurrentPortfolioValues(dictionary: dictionary)
        
        
    }
    

    private func populatePastPortfolios(dictionary: Dictionary<String, Any>) {
        
        pastPortfolios = []
        
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

    private func populatePerformanceData(dictionary: Dictionary<String, Float>) {
        totalIndexPerformance = dictionary["index"] ?? 200
        totalStockGeniusPerformance = dictionary["stockGenius"] ?? 300
    }
    
    private func sortPastPortfolios() {
        pastPortfolios.sort(by: {$0.rank > $1.rank})
    }
    
    public func localURLFromFileName(_ name: String) -> URL? {
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        if let docURL = directory {
            let fileName = "\(name).png"
            let localURL = docURL.appendingPathComponent(fileName)
            return localURL
        } else {
            return nil
        }
    }
    
    

}
