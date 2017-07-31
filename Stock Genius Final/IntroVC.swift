//
//  IntroVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol IntroVCDelegate: class {
    func userChoice(_ choice: IntroScreenChoice)
}

class IntroVC: UIViewController, IntroScreenDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var circleTabView: CircleTabView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var pictureScrollView: UIScrollView!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var introSplashScreen: IntroSplashScreen!
    @IBOutlet weak var girlScrollView: UIScrollView!
    @IBOutlet weak var girlView: GirlView!
    @IBOutlet weak var lastIntroPage: LastIntroPage!
    weak var delegate : IntroVCDelegate?
    var isTestMode = true
    var frameWidth : CGFloat = 375
    var viewHasAppeared = false
    var readyToPresent = false
    var images : [UIImage] = []
    let spinnerVC: SpinnerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "spinnerVC") as! SpinnerVC
        var lastAtIndexZeroRatherThanOne = true
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var otherBackgroundImageView: UIImageView!
    
    @IBOutlet weak var page1: Page1!
    @IBOutlet weak var page1Background: UIImageView!
    @IBOutlet weak var page2: UIImageView!
    @IBOutlet weak var page3: UIImageView!
    @IBOutlet weak var page4: UIImageView!
    @IBOutlet weak var page5: UIImageView!
    @IBOutlet weak var graphicPage1: UIImageView!
    @IBOutlet weak var graphicPage2: UIImageView!


    override func viewDidLoad() {
        mainScrollView.alpha = 0
        super.viewDidLoad()
        frameWidth = view.frame.width
        formatScrollView()
        lastIntroPage.delegate = self
        view.isUserInteractionEnabled = false
        addIAPObservers()
        circleTabView.alpha = 0
        backgroundView.backgroundColor = SGConstants.mainBlackColor
        backgroundView.alpha = 0
        print("\(view.frame.width) by \(view.frame.height)")
        logoImageView.alpha = view.frame.height == 480 ? 0 : 1
        
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        viewHasAppeared = true
        
        if readyToPresent {
            assignImages()
            layOutAllViews()
        }
    }
    
    public func readyToPresent(success: Bool) {
        
        if viewHasAppeared && success {
            assignImages()
            layOutAllViews()
        } else if success {
            readyToPresent = true
        }

    }
    
    public func layOutAllViews() {
        
        introSplashScreen.animateLogoToTop {
            UIView.animate(withDuration: 0.3, animations: {
                self.introSplashScreen.alpha = 0
            }, completion: { (complete) in
                self.girlView.animateGirlImage {
                    UIView.animate(withDuration: 0.4, delay: 0.7, options: [], animations: {
                        self.mainScrollView.alpha = 1
                    }, completion: { (complete) in
                        self.view.isUserInteractionEnabled = true
                    })
                }
            })
        }

    }
    
    public func assignImages() {
        
        let isSmall = view.frame.height == 480
        
        for index in 0...DataStore.shared.imageNames.count - 1 {
            
            let url = DataStore.shared.localURLFromFileName(DataStore.shared.imageNames[index])!
            let fileName = url.path
            let image = (isSmall && index == 7) ? UIImage(named: "altLastIntro") : UIImage(contentsOfFile: fileName)!
            let imageView = imageViewForIndex(index)
            imageView.image = image
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
    
    private func imageViewForIndex(_ index: Int) -> UIImageView {
        
        
        
        switch index {
        case 0:
            return page1Background
        case 1:
            return girlView.girlImageView
        case 2:
            return self.page1.mainImageView
        case 3:
            return self.page2
        case 4:
            return self.page3
        case 5:
            return self.page4
        case 6:
            return self.page5
        case 7:
            return self.lastIntroPage.mainImageView
        case 8:
            return self.graphicPage1
        case 9:
            return self.graphicPage2
        case 10:
            return self.otherBackgroundImageView
        default:
            return UIImageView()
        }
    }
    
    
    func introScreenUserInteraction(_ choice: IntroScreenChoice) {
        
        switch choice {
        case .subscribe:
            handleSubscribeTapped()
        case .restore:
            handleRestoreTapped()
        case .terms:
            presentModalForChoice(.terms)
        case .privacy:
            presentModalForChoice(.privacy)
        case .billing:
            presentModalForChoice(.billing)
        }
    }
    
    func presentModalForChoice(_ choice: IntroScreenChoice) {
        
        let termsVC: TermsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "termsVC") as! TermsVC
        termsVC.choice = choice
        view.isUserInteractionEnabled = false
        present(termsVC, animated: true) { 
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleSubscribeTapped() {
        
        if IAPClient.shared.IAPProductsAvailable {
            showSpinnerView()
            IAPClient.shared.upgradeToFullVersion(testMode: isTestMode)
        } else {
            self.presentAlertToUser(title: "Can't connect to Apple", message: "Please try again")
            IAPClient.shared.fetchProducts()
        }
    }
    
    func handleRestoreTapped() {
        if IAPClient.shared.IAPProductsAvailable {
            showSpinnerView()
            IAPClient.shared.restorePreviousPurchase()
        } else {
            self.presentAlertToUser(title: "Can't connect to Apple", message: "Please try again")
            IAPClient.shared.fetchProducts()
        }
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
        dismissSpinnerView()
    }
    
    func handleRestoreFail(notification:NSNotification) {
        dismissSpinnerView()
        self.presentAlertToUser(title: "Cannot Restore", message: "No purchase found")
    }
    
    func handlePurchaseDeferred(notification: NSNotification) {
        dismissSpinnerView()
        self.presentAlertToUser(title: "Purchase Deferred", message: "Awaiting approval")
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
        formatCircleView(offset: point)
        
    }
    
    func formatCircleView(offset: CGPoint) {
        
        if lastAtIndexZeroRatherThanOne {
            circleTabView.alpha =  offset.x / view.frame.width < 1 ? 0 : 1
        } else {
            circleTabView.alpha = offset.x / view.frame.width
        }
        
        if offset.x == 0 {
            lastAtIndexZeroRatherThanOne = true
        }
        if offset.x == view.frame.width {
            lastAtIndexZeroRatherThanOne = false
        }
        
        circleTabView.formatCircleViewForOffset(offset, frameWidth: view.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // nothing here for now
    }
    
    func formatOtherViews(offset: CGPoint) {
        formatBackgroundImageView(offset: offset)
        formatBackgroundScrollView(offset: offset)
        formatGirlView(offset: offset)
        formatPictureView(offset: offset)
        formatBackgroundView(offset: offset)
    }
    
    func formatBackgroundView(offset: CGPoint) {
        
        let minOffset : CGFloat = view.frame.width * 4.0
        backgroundView.alpha = offset.x < minOffset ? 0.0 : (offset.x - minOffset) / view.frame.width

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
            let scrollAmount = (offset.x - frameWidth) / 20
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
