//
//  UnableToConnectVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol UnableToConnectVCDelegate : class {
    func tryAgainTapped()
}

class UnableToConnectVC: UIViewController {

    @IBOutlet weak var tryAgainButton: UIButton!
    weak var delegate : UnableToConnectVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tryAgainButton.backgroundColor = SGConstants.mainBlueColor
        view.backgroundColor = SGConstants.mainBlackColor
        tryAgainButton.layer.cornerRadius = 10
    }

    @IBAction func tryAgainTapped(_ sender: Any) {
        delegate?.tryAgainTapped()
    }

}
