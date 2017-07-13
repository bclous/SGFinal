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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SGConstants.mainBlackColor
        DataStore.shared.delegate = self
        DataStore.shared.performInitialFirebasePull()
        progressView.progress = 0.0
        progressView.progressTintColor = SGConstants.mainBlueColor
        invalidVC.delegate = self
        addIAPObservers()
        
    }
    
    func checkForValidSubscription() {
        IAPClient.shared.checkSubscriptionStatus()
    }
    
    func addIAPObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBadSubscription),
                                               name: IAPClient.subscriptionNoLongerValid,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleResubscribe),
                                               name: IAPClient.purchaseSuccessfulNotification,
                                               object: nil)
    }
    
    func subscripeTapped() {
        invalidVC.dismiss(animated: false) {
            self.showSpinnerView()
            self.handleSubscribeTapped()
        }
    }
    
    func handleBadSubscription() {
        badSubscription = true
        showInvalidVC()

    }
    
    func handleResubscribe() {
        UserDefaults.standard.set(true, forKey: "payingUser")
        spinnerVC.dismiss(animated: false) { 
            if self.readyToSegue {
                self.performSegue(withIdentifier: "mainSegue", sender: nil)
            } else {
                self.badSubscription = false
            }
        }
       
    }
    
    func showInvalidVC() {
        invalidVC.modalPresentationStyle = .overCurrentContext
        present(invalidVC, animated: false) {
            // start IAP
        }
    }
    
    func dismissInvalidVC() {
        invalidVC.dismiss(animated:false) { 
            if self.readyToSegue {
                self.performSegue(withIdentifier: "mainSegue", sender: nil)
            } else {
                self.badSubscription = false
            }
        }
    }
    
    public func showSpinnerView() {
        
        spinnerVC.modalPresentationStyle = .overCurrentContext
        present(spinnerVC, animated: false) {
            // start IAP
        }
    }
    
    public func dismissSpinnerView() {
        spinnerVC.dismiss(animated: false, completion: nil)
    }
    
    func handleSubscribeTapped() {
        
        if IAPClient.shared.IAPProductsAvailable {
            IAPClient.shared.upgradeToFullVersion(testMode: isTestMode)
        } else {
            self.presentAlertToUser(title: "Can't connect to Apple", message: "Please try again")
            IAPClient.shared.fetchProducts()
        }
    }
    
    func presentAlertToUser(title: String, message:String) {
        let importAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        importAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(importAlert, animated: true, completion: nil)
    }

    
    
    
    
 

    func initialImagePullComplete(success: Bool) {
        // do nothing
    }
    
    func firebasePullComplete(success: Bool) {
        //stff
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
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabBarController

    }
   

}
