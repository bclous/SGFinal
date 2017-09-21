//
//  SplashScreenVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {

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
        collectAppData()
        labelScrollView.isHidden = true
        progressView.isHidden = true
        
    }
    
    func collectAppData() {
        
        DataStore.shared.collectAppDataForLaunch { (success) in
            self.readyToPresent(success)
        }
    }
    
    func readyToPresent(_ ready: Bool) {
        if ready {
            performSegue(withIdentifier: "mainSegue", sender: nil)
        } else {
            present(unableToConnectVC, animated: false, completion: nil)
        }
    }
    
    private func formatView() {
        view.backgroundColor = SGConstants.mainBlackColor
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
        unableToConnectVC.dismiss(animated: false, completion: nil)
        collectAppData()
    }
}
