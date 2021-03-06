//
//  AppDelegate.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isTestMode = false
    let introVC : IntroVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introVC") as! IntroVC
    var isInMainWindow = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        checkForFirstTime()
        SKPaymentQueue.default().add(self)
        IAPClient.shared.fetchProducts()
        return true
    }
    
    func checkForFirstTime() {
        if !userHasPictures() {
            introVC.isTestMode = isTestMode
            window?.rootViewController = introVC
            FirebaseClient.shared.downloadImagesFromStorage(completion: { (success) in
                if success {
                    UserDefaults.standard.set(true, forKey: "userHasPictures")
                    self.introVC.readyToPresent(success: success)
                } else {
                    // show sorry screen
                }
            })
        } else {
            setInitialView()
        }
    }
    
    func setInitialView() {

        if isPayingUser() && !isTestMode {
            isInMainWindow = true
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        } else {
            introVC.isTestMode = isTestMode
            introVC.readyToPresent(success: true)
            window?.rootViewController = introVC
        }
        
    }
    
    func userHasPictures() -> Bool {
        if UserDefaults.standard.object(forKey: "userHasPictures") == nil {
            UserDefaults.standard.set(false, forKey: "userHasPictures")
            return false
        } else {
            return UserDefaults.standard.object(forKey: "userHasPictures") as! Bool
        }

    }
    
    func isPayingUser() -> Bool {

        if UserDefaults.standard.object(forKey: "payingUser") == nil {
            UserDefaults.standard.set(false, forKey: "payingUser")
            return false
        } else {
            return UserDefaults.standard.object(forKey: "payingUser") as! Bool
        }
        
    }
    
    func purchaseComplete() {
        updateUserSubscriptionStatusForNewPurchase()
        moveToMainViews()
    }
    
    func updateUserSubscriptionStatusForNewPurchase() {
        UserDefaults.standard.set(true, forKey: "payingUser")
        UserDefaults.standard.set(Date(), forKey: "lastPaymentDate")
    }
    
    func moveToMainViews() {
        
        if let window = window {
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            isInMainWindow = true
        }
    }
    
    func initialImagePullComplete(success: Bool) {
        UserDefaults.standard.set(true, forKey: "userHasPictures")
        introVC.readyToPresent(success: success)
    }
    
    func firebasePullComplete(success: Bool) {
        // do nothing
    }
    
    func pricePullComplete(success: Bool) {
        // do nothing
    }
    
    func pricePullInProgress(percentageComplete: Float) {
        // do nothing
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Stock_Genius_Final")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
            case .restored:
                handleRestoredState(for: transaction, in: queue)
            case .failed:
                handleFailedState(for: transaction, in: queue)
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
            }
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: IAPClient.restoreFailedNotification, object: nil)
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: IAPClient.restoreSuccessfulNotification, object: nil)
        }
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
        // queue.finishTransaction(transaction)
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User purchased product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        
        if isInMainWindow {
            DispatchQueue.main.async {
                self.updateUserSubscriptionStatusForNewPurchase()
                NotificationCenter.default.post(name: IAPClient.purchaseSuccessfulNotification, object: nil)
            }
        } else {
            purchaseComplete()
        }
       
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase restored for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        if isInMainWindow {
            DispatchQueue.main.async {
                self.updateUserSubscriptionStatusForNewPurchase()
                NotificationCenter.default.post(name: IAPClient.restoreSuccessfulNotification, object: nil)
            }
        } else {
            purchaseComplete()
        }
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: IAPClient.purchaseFailedNotification, object: nil)
        }
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: IAPClient.purchaseDeferredNotification, object: nil)
        }
    }
    
}


