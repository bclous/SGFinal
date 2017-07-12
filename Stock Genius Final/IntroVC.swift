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
        super.viewDidLoad()
        frameWidth = view.frame.width
        formatScrollView()
        lastIntroPage.delegate = self
        view.isUserInteractionEnabled = false


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    self.view.isUserInteractionEnabled = true
                }
            })
        }

    }
    
    public func assignImages() {
        
        for index in 0...DataStore.shared.imageNames.count - 1 {
            let url = DataStore.shared.localURLFromFileName(DataStore.shared.imageNames[index])!
            let fileName = url.path
            let image = UIImage(contentsOfFile: fileName)!
            let imageView = imageViewForIndex(index)
            imageView.image = image
        }
    }
    
    public func showSpinnerView() {
        
    }
    
    public func dismissSpinnerView() {
        
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
        delegate?.userChoice(choice)
        if choice == .terms {
            // launch modal VC w/ terms
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension IntroVC: UIScrollViewDelegate {
    
    func formatScrollView() {
        mainScrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let point = CGPoint(x: offset, y: 0)
        formatOtherViews(offset: point)
        
//        circlesClearUntilPage1 = scrollView.contentOffset.x == 0 ? true : circlesClearUntilPage1
//        
//        if scrollView.contentOffset.x < frameWidth {
//            circleStackView.alpha = circlesClearUntilPage1 ? 0 : scrollView.contentOffset.x / frameWidth
//        } else {
//            circlesClearUntilPage1 = false
//            circleStackView.alpha = 1
//        }
//        
//        let indexFloat : CGFloat = scrollView.contentOffset.x / frameWidth
//        var indexInt : Int = 0
//        
//        switch indexFloat {
//        case 0...1.499:
//            indexInt = 0
//        case 1.499...2.499:
//            indexInt = 1
//        case 2.499...3.499:
//            indexInt = 2
//        case 3.499...4.499:
//            indexInt = 3
//        case 4.499...6:
//            indexInt = 4
//        default:
//            indexInt = 0
//        }
//        
//        adjustCirclesToIndex(indexInt)
        
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
