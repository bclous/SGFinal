//
//  SplashScreenVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController, DataStoreDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelScrollView: LabelScrollView!
    var currentLabelPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SGConstants.mainBlackColor
        DataStore.shared.delegate = self
        DataStore.shared.performInitialFirebasePull()
        progressView.progress = 0.0
        progressView.progressTintColor = SGConstants.mainBlueColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialImagePullComplete(success: Bool) {
        // do nothing
    }
    
    func firebasePullComplete(success: Bool) {
        //stff
    }
    
    func pricePullComplete(success: Bool) {
        progressView.progress = 1.0
        performSegue(withIdentifier: "mainSegue", sender: nil)
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
