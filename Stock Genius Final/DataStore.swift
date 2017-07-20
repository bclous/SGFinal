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
    func initialImagePullComplete(success: Bool)
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
    var totalIndexPerformance : Float
    var totalStockGeniusPerformance : Float
    var imageNames = ["page1Background", "girl", "mainPage1", "mainPage2", "mainPage3", "mainPage4", "mainPage5", "mainPage6","graphicPage1", "graphicPage2", "otherBackground"]

    
    private override init() {
        self.currentPortfolio = CurrentPortfolio()
        self.pastPortfolios = []
        self.ref = Database.database().reference()
        self.totalIndexPerformance = 300
        self.totalStockGeniusPerformance = 200
        super.init()
        FirebaseClient.shared.delegate = self
        AlphaVantageClient.shared.delegate = self
    }
    
    func peformIntroScreenImagePull() {
        FirebaseClient.shared.performIntroScreenImagePull()
    }
    
    func performInitialFirebasePull() {
        FirebaseClient.shared.performInitialDatabasePull()
    }
    
    func pricePullComplete(success: Bool) {
        delegate?.pricePullComplete(success: success)
    }
    
    func pricePullInProgressFromAV(percentageComplete: Float) {
        delegate?.pricePullInProgress(percentageComplete: percentageComplete)
    }

    
    func fireBasePullComplete(success: Bool) {
        delegate?.firebasePullComplete(success: success)
    }
    
    func imagePullComplete(success: Bool) {
        delegate?.initialImagePullComplete(success: success)
    }
    
    public func populateAppWithData(dictionary: Dictionary<String, Any>) {
        let currentPortfolioDictionary = dictionary["currentPortfolio"] as? Dictionary<String, Any>
        let pastPortfoliosDictionary = dictionary["pastPortfolios"] as? Dictionary<String, Any>
        let appInfo = dictionary["appInfo"] as? Dictionary<String, Any>
        let performance = dictionary["performance"] as? Dictionary<String, Float>
        
        if currentPortfolioDictionary != nil && pastPortfoliosDictionary != nil && appInfo != nil {
            populateCurrentPortfolio(dictionary: currentPortfolioDictionary!)
            populatePastPortfolios(dictionary: pastPortfoliosDictionary!)
            populateAppWithData(dictionary: appInfo!)
            populatePerformanceData(dictionary: performance!)
            AlphaVantageClient.shared.updatePricesForCurrentPortfolio()
        } else {
            // send out fail
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