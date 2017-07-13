//
//  SplashScreenVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController, DataStoreDelegate, InvalidSubscriptionDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelScrollView: LabelScrollView!
    var currentLabelPage = 0
    var badSubscription = false
    var readyToSegue = false
    let spinnerVC: SpinnerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spinnerVC") as! SpinnerVC
    let invalidVC: InvalidSubscriptionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invalidSubscriptionVC") as! InvalidSubscriptionVC
    var isTestMode = true
    var spinnerViewShowing = false
    var badSubscriptionScreenShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        DataStore.shared.performInitialFirebasePull()
    }
    
    private func formatView() {
        view.backgroundColor = SGConstants.mainBlackColor
        DataStore.shared.delegate = self
        progressView.progress = 0.0
        progressView.progressTintColor = SGConstants.mainBlueColor
        invalidVC.delegate = self
        addIAPObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        checkForValidSubscription()
    }
    
    func checkForValidSubscription() {
        let lastPurchaseDate = UserDefaults.standard.object(forKey: "lastPaymentDate") as? Date
        if let date = lastPurchaseDate {
            let daysSincePurchase = date.interval(ofComponent: .day, fromDate: Date())
            if abs(daysSincePurchase) > 35 {
                handleBadSubscription()
            }
        } else {
            handleBadSubscription()
        }

    }
    
    func subscripeTapped() {
        
        invalidVC.dismiss(animated: false) {
            self.showSpinnerView()
            
            if IAPClient.shared.IAPProductsAvailable {
                IAPClient.shared.upgradeToFullVersion(testMode: self.isTestMode)
            } else {
                self.presentAlertToUser(title: "Can't connect to Apple", message: "Please try again")
                IAPClient.shared.fetchProducts()
            }
        }
    }
    
    func handleBadSubscription() {
        UserDefaults.standard.set(false, forKey: "payingUser")
        badSubscription = true
        showInvalidVC()

    }
    
    func handleRestoreAccess() {
        
        if spinnerViewShowing {
            dismissSpinnerView()
        }
        if badSubscriptionScreenShowing {
            dismissInvalidVC()
        }
        
        if self.readyToSegue {
            self.performSegue(withIdentifier: "mainSegue", sender: nil)
        } else {
            self.badSubscription = false
        }

    }
    
    
    func handleRestoreFailure() {
        handleBadSubscription()
    }
    
    
    
    func pricePullComplete(success: Bool) {
        progressView.progress = 1.0
        if !badSubscription {
            performSegue(withIdentifier: "mainSegue", sender: nil)
        } else {
            readyToSegue = true
        }
        
    }
    
    func pricePullInProgress(percentageComplete: Float) {
        DispatchQueue.main.async {
            self.progressView.setProgress(percentageComplete, animated: true)
            
            if percentageComplete > 0.15 && percentageComplete < 0.45 {
                
                if self.currentLabelPage != 1 {
                    self.labelScrollView.adjustScrollViewToPage(1, animated: true)
                    self.currentLabelPage = 1
                }
            } else if percentageComplete >= 0.45 && percentageComplete < 0.80 {
                if self.currentLabelPage != 2 {
                    self.labelScrollView.adjustScrollViewToPage(2, animated: true)
                    self.currentLabelPage = 2
                }
            } else if percentageComplete >= 0.80 {
                if self.currentLabelPage != 3 {
                    self.labelScrollView.adjustScrollViewToPage(3, animated: true)
                    self.currentLabelPage = 3
                }
            }
        }
    }
    
    func addIAPObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRestoreAccess),
                                               name: IAPClient.purchaseSuccessfulNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRestoreAccess),
                                               name: IAPClient.restoreSuccessfulNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRestoreFailure),
                                               name: IAPClient.restoreFailedNotification,
                                               object: nil)
    }
    
    // unused delegate functions
    
    func initialImagePullComplete(success: Bool) {
        // do nothing
    }
    
    func firebasePullComplete(success: Bool) {
        //stff
    }
    
    // helper methods
    
    private func presentAlertToUser(title: String, message:String) {
        let importAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        importAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(importAlert, animated: true, completion: nil)
    }
    
    func showInvalidVC() {
        invalidVC.modalPresentationStyle = .overCurrentContext
        present(invalidVC, animated: false) {
            self.badSubscriptionScreenShowing = true
        }
    }
    
    func dismissInvalidVC() {
        invalidVC.dismiss(animated:false) {
            self.badSubscriptionScreenShowing = false
        }
    }
    
    public func showSpinnerView() {
        
        spinnerVC.modalPresentationStyle = .overCurrentContext
        present(spinnerVC, animated: false) {
            self.spinnerViewShowing = true
        }
    }
    
    public func dismissSpinnerView() {
        spinnerVC.dismiss(animated: false) {
            self.spinnerViewShowing = false
        }
    }

   

}
