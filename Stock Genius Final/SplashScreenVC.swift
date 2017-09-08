//
//  SplashScreenVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController, DataStoreDelegate {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var noEyesLogoImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelScrollView: LabelScrollView!
    var currentLabelPage = 0
    var badSubscription = false
    var readyToSegue = false
    let spinnerVC: SpinnerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spinnerVC") as! SpinnerVC
    let unableToConnectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "unableToConnect") as! UnableToConnectVC
    var isTestMode = true
    var spinnerViewShowing = false
    var badSubscriptionScreenShowing = false
    var normalLogoShowing = true
    var currentPicksNeedsPriceUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()
        formatUnableToConnectView()
        refreshSplashView()
        labelScrollView.isHidden = true
        progressView.isHidden = true
        
    }
    
    func refreshSplashView() {
        
        progressView.progress = 0.0
        DataStore.shared.performInitialFirebasePull { (success) in
            
            if DataStore.shared.appNeedsFullUpdateOnSplashScreen() {
                self.labelScrollView.isHidden = false
                self.progressView.isHidden = false
                DataStore.shared.performUpdatePricesPull(completion: { (success) in
                    
                    self.readyToPresent(success)
                })
            } else {
                DataStore.shared.currentPortfolio.updatePricesFromCache()
                self.currentPicksNeedsPriceUpdate = success
                self.readyToPresent(success)
            }
            
        }
    }
    
    func readyToPresent(_ ready: Bool) {
        if ready {
            progressView.progress = 1.0
            performSegue(withIdentifier: "mainSegue", sender: nil)
        } else {
            present(unableToConnectVC, animated: false, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabBarController
        destinationVC.currentPicksNeedsUpate = currentPicksNeedsPriceUpdate
    }
    
    private func formatView() {
        view.backgroundColor = SGConstants.mainBlackColor
        DataStore.shared.delegate = self
        progressView.progress = 0.0
        progressView.progressTintColor = SGConstants.mainBlueColor
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
    
 
    // helper methods
    
    private func presentAlertToUser(title: String, message:String) {
        let importAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        importAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(importAlert, animated: true, completion: nil)
    }


}

extension SplashScreenVC : UnableToConnectVCDelegate {
    
    func formatUnableToConnectView() {
        unableToConnectVC.delegate = self
    }
    
    func tryAgainTapped() {
        refreshSplashView()
        unableToConnectVC.dismiss(animated: false, completion: nil)
    }
}
