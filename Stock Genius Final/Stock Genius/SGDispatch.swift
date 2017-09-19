//
//  SGDispatch.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/13/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation

protocol SGDispatchDelegate: class {
    func readyToPresent(success: Bool)
    func refreshComplete(success: Bool)
}

class SGDispatch: NSObject, FBClientDelegate, YahooBigBoardDelegate {
    
    static let shared = SGDispatch()
    weak var delegate : SGDispatchDelegate?
    
    var currentPortfolio : Portfolio?
    var pastPortfolios : [Portfolio] = []
    
    private override init () {
        super.init()
        FBClient.shared.delegate = self
        YahooBigBoardClient.shared.delegate = self
    }
    
    func firebasePullComplete(success: Bool) {
        updatePortfolios()
        updatePricesFirstTime()
    }
    
    func pricePullComplete(success: Bool) {
        delegate?.readyToPresent(success: success)
    }
    
    func priceRefreshComplete(success: Bool) {
        delegate?.refreshComplete(success: success)
    }
    
    func updatePricesFirstTime() {
        YahooBigBoardClient.shared.updatePrices(portfolio: currentPortfolio, firstTime: true)
    }
    
    func refreshPrices() {
        YahooBigBoardClient.shared.updatePrices(portfolio: currentPortfolio, firstTime: false)
    }
    
    func updatePortfolios() {
        currentPortfolio = CDClient.currentPortfolioFetch()
        pastPortfolios = CDClient.pastPortfoliosFetch()
    }
    
    func performInitialFireBasePull() {
        FBClient.shared.initialFireBasePull()
    }
    
    func holdingsInOrder() -> [Holding]? {
        
        let holdingsArray = currentPortfolio?.holdings?.allObjects as? [Holding]
        
        if let holdings = holdingsArray {
            let sortedHoldings = holdings.sorted(by: {$0.rank < $1.rank})
            return sortedHoldings
        } else {
            return nil
        }
        
    }
}
