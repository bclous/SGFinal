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
}

class InvalidSubscriptionVC: UIViewController {

    weak var delegate : InvalidSubscriptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subscripeTapped(_ sender: Any) {
        delegate?.subscripeTapped()
    }


}
