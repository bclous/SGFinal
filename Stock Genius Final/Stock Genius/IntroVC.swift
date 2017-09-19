//
//  IntroVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/7/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol IntroVCDelegate : class {
    func purchaseComplete()
}

class IntroVC: UIViewController, IntroSplashScreenDelegate, Page5Delegate {

  
    @IBOutlet weak var spinnerView: SpinnerView!
    @IBOutlet weak var pictureScrollView: UIScrollView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var girlScrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var circleStackView: UIStackView!
    @IBOutlet weak var page5: Page5!
    @IBOutlet weak var introSplashScreen: IntroSplashScreenView!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    weak var delegate: IntroVCDelegate?
    
    var isTestMode = false 
  
    var frameWidth : CGFloat = 375
    var circlesClearUntilPage1 = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatCircleStackView()
        formatScrollView()
        frameWidth = view.frame.width
        formatIntroView()
        introSplashScreen.delegate = self
        page5.delegate = self
        addIAPObservers()
    }
    
    func addIAPObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseFail(notification:)),
                                               name: IAPClient.purchaseFailedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseDeferred(notification:)),
                                               name: IAPClient.purchaseDeferredNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseFail(notification:)),
                                               name: IAPClient.restoreFailedNotification,
                                               object: nil)
    }
    

    
    func handlePurchaseFail(notification: NSNotification) {
        spinnerView.isHidden = true
    }
    
    func handleRestoreFail(notification:NSNotification) {
        spinnerView.isHidden = true
        self.presentAlertToUser(title: "Cannot Restore", message: "No purchase found")
    }
    
    func handlePurchaseDeferred(notification: NSNotification) {
        spinnerView.isHidden = true
        self.presentAlertToUser(title: "Purchase Deferred", message: "Awaiting approval")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        introSplashScreen.adjustLogoToTop(animate: true)
    }

    func formatCircleStackView() {
        for view in circleStackView.arrangedSubviews {
            view.layer.cornerRadius = 6
        }
        adjustCirclesToIndex(0)
        circleStackView.alpha = 0
    }
    
    func adjustCirclesToIndex(_ index: Int) {
        for view in circleStackView.arrangedSubviews {
            view.backgroundColor = UIColor.lightGray
        }
        circleStackView.arrangedSubviews[index].backgroundColor = SGConstants.mainBlueColor
    }
    
    func formatIntroView() {
        backgroundScrollView.alpha = 0
    }
    
    func splashScreenAnimationComplete() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.introSplashScreen.alpha = 0
        }) { (complete) in
            // anything?
        }
    }
    
    func getStartedTapped() {
        
        if IAPClient.shared.IAPProductsAvailable {
            spinnerView.isHidden = false
            IAPClient.shared.upgradeToFullVersion(testMode: isTestMode)
        } else {
            presentAlertToUser(title: "Can't connect to iTunes", message: "Please try again")
        }
       
    }
    
    func restorePurchaseTapped() {
        
        if IAPClient.shared.IAPProductsAvailable {
            spinnerView.isHidden = false
            if isTestMode {
                delegate?.purchaseComplete()
            } else {
                IAPClient.shared.restorePreviousPurchase()
            }
            
        } else {
            presentAlertToUser(title: "Can't connect to iTunes", message: "Please try again")
        }

    }
    
    func termsTapped() {
        // present VC to do stuff
    }
    
    func presentAlertToUser(title: String, message:String) {
        let importAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        importAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(importAlert, animated: true, completion: nil)
    }

}


extension IntroVC: UIScrollViewDelegate {
    
    func formatScrollView() {
        mainScrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let point = CGPoint(x: offset, y: 0)
        formatOtherViews(offset: point)
        
        circlesClearUntilPage1 = scrollView.contentOffset.x == 0 ? true : circlesClearUntilPage1
        
        if scrollView.contentOffset.x < frameWidth {
            circleStackView.alpha = circlesClearUntilPage1 ? 0 : scrollView.contentOffset.x / frameWidth
        } else {
            circlesClearUntilPage1 = false
            circleStackView.alpha = 1
        }
        
        let indexFloat : CGFloat = scrollView.contentOffset.x / frameWidth
        var indexInt : Int = 0
        
        switch indexFloat {
        case 0...1.499:
            indexInt = 0
        case 1.499...2.499:
            indexInt = 1
        case 2.499...3.499:
            indexInt = 2
        case 3.499...4.499:
            indexInt = 3
        case 4.499...6:
            indexInt = 4
        default:
            indexInt = 0
        }

        adjustCirclesToIndex(indexInt)
    
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // nothing here for now
    }
    
    func formatOtherViews(offset: CGPoint) {
        formatBackgroundImageView(offset: offset)
        formatBackgroundScrollView(offset: offset)
        formatGirlView(offset: offset)
        formatPictureView(offset: offset)
    }
    
    func formatPictureView(offset: CGPoint) {
        if offset.x <= frameWidth {
            pictureScrollView.setContentOffset(offset, animated: false)
        } else if offset.x <= frameWidth * 3.0 {
            let newOffset = ((offset.x - frameWidth) / 2) + frameWidth
            let newPoint = CGPoint(x: newOffset, y: 0)
            pictureScrollView.setContentOffset(newPoint, animated: false)
        } else {
            let newOffset = offset.x - (frameWidth)
            let newPoint = CGPoint(x: newOffset, y: 0)
            pictureScrollView.setContentOffset(newPoint, animated: false)
        }
        
    }
    
    func formatBackgroundImageView(offset: CGPoint) {
        
        if offset.x <= frameWidth {
            backGroundImage.alpha = 1 - (offset.x / frameWidth)
        }
        
    }
    
    func formatBackgroundScrollView(offset: CGPoint) {
        
        if offset.x <= frameWidth {
            backgroundScrollView.alpha = (offset.x / frameWidth)
            let newPoint = CGPoint(x: frameWidth, y: 0)
            backgroundScrollView.setContentOffset(newPoint, animated: false)
        } else {
            let scrollAmount = (offset.x - frameWidth) / 10
            let newPoint = CGPoint(x: frameWidth - scrollAmount, y: 0)
            //let point = CGPoint(x: (offset.x - frameWidth) / 5.0, y: 0)
            backgroundScrollView.setContentOffset(newPoint, animated: false)
        }
        
    }
    
    func formatGirlView(offset: CGPoint) {
        
        let multiplier : CGFloat = 0.2
        
        if offset.x <= frameWidth {
            if offset.x <= multiplier * frameWidth {
                let girlOffset = CGPoint(x: multiplier * offset.x, y: 0)
                girlScrollView.setContentOffset(girlOffset, animated: false)
            } else {
                let newX = (multiplier * multiplier * frameWidth) + ((1 + multiplier) * (offset.x - frameWidth * multiplier))
                let newPoint = CGPoint(x: newX, y: 0)
                girlScrollView.setContentOffset(newPoint, animated: false)
            }
        }
    }
    
  
}
