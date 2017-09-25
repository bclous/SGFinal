//
//  PictureVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Alamofire

protocol PictureVCDelegate : class {
    func screenTapped()
}

class PictureVC: UIViewController {
    
    var message : STMessage?
    @IBOutlet weak var mainImageView: UIImageView!
    weak var delegate : PictureVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SGConstants.mainBlackColor
        mainImageView.backgroundColor = SGConstants.mainBlackColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatVCForPicture()
    }
    
    func formatImage() -> Bool {
        
        if let highResImage = message?.messageImage(isLowRes: false) {
            mainImageView.image = highResImage
            return false
        } else {
            if let lowResImage = message?.messageImage(isLowRes: true) {
                
                mainImageView.image = lowResImage
                return true
            } else {
                return true
            }
        }

    }
    
    func formatVCForPicture() {
        let needsHighRes = formatImage()
        if needsHighRes {
            let highResAddress = message?.highResImageAddress()
            if let address = highResAddress {
                Alamofire.request(address).responseData(completionHandler: { (response) in
                    if let data = response.result.value {
                        self.mainImageView.image = UIImage(data: data)
                        self.message?.cacheMessageImage(UIImage(data: data)!, isLowRes: false)
                    }
                })
            }
        }

    }

    @IBAction func screenTapped(_ sender: Any) {

        delegate?.screenTapped()
    }
}
