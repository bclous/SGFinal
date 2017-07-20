//
//  InvalidSubscriptionVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/13/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol InvalidSubscriptionDelegate : class {
    func subscripeTapped()
    func restoreTapped()
}

class InvalidSubscriptionVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    weak var delegate : InvalidSubscriptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 10
        subscribeButton.layer.cornerRadius = 10
        subscribeButton.backgroundColor = SGConstants.mainBlueColor
        backgroundView.backgroundColor = SGConstants.mainBlackColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subscripeTapped(_ sender: Any) {
        delegate?.subscripeTapped()
    }

    @IBAction func restoreTapped(_ sender: Any) {
        delegate?.restoreTapped()
    }

}
