//
//  SpinnerVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/13/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SpinnerVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor.white
        containerView.alpha = 0.3
        spinnerView.startAnimating()
        view.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func dismissSpinnerVC() {
        self.dismiss(animated: false, completion: nil)
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
