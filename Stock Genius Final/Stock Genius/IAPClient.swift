//
//  IAPClient.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/16/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import StoreKit


class IAPClient: NSObject, SKProductsRequestDelegate, SKRequestDelegate {
    
    static let restoreSuccessfulNotification = Notification.Name("restoreSuccessful")
    static let restoreFailedNotification = Notification.Name("restoreFailed")
    static let purchaseSuccessfulNotification = Notification.Name("purchaseSuccessful")
    static let purchaseFailedNotification = Notification.Name("purchaseFailed")
    static let purchaseDeferredNotification = Notification.Name("purchaseDeferred")
    static let subscriptionNoLongerValid = Notification.Name("subscriptionNoLongerValid")
    
    static let shared = IAPClient()
    
    var isUpgraded = false
    var IAPProductsAvailable = false
    var isPurchaseInProgress = false
    var upgradeProduct : SKProduct?
    var testProduct : SKProduct?
    var upgradeProductIdentifier = "SGTest2"
    var testProductIdentifier = "SGTestConsumable"
    
    
    func restorePreviousPurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func upgradeToFullVersion(testMode: Bool) {
        
        if let product = testMode ? testProduct : upgradeProduct {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func fetchProducts() {
        
        var identifiers = Set<String>()
        identifiers.insert(upgradeProductIdentifier)
        identifiers.insert(testProductIdentifier)
        if (SKPaymentQueue.canMakePayments()) {
            let request = SKProductsRequest(productIdentifiers: identifiers)
            request.delegate = self
            request.start()
        } else {
            IAPProductsAvailable = false
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("\(error)")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count > 0 {
            print("found product")
            IAPProductsAvailable = true
            testProduct = response.products[0].productIdentifier ==
                "SGTestConsumable" ? response.products[0] as SKProduct : response.products[1] as SKProduct
            upgradeProduct = response.products[0].productIdentifier ==
                "SGTestConsumable" ? response.products[1] as SKProduct : response.products[0] as SKProduct
        }
        else {
            IAPProductsAvailable = false
        }
    }
    
    
    public func checkSubscriptionStatus() {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return
        }
        do {
            let receipt = try Data(contentsOf: url)
        } catch {
            
        }
        
    }
    
    public func requestNewReciept() {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }
    
}

extension SKProduct {
    
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
    
}


