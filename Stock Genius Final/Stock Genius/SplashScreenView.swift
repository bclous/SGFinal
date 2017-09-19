//
//  SplashScreenView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/7/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SplashScreenView: UIView {
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet var contentView: UIView!
    var rotate = true

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SplashScreenView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    
    func rotateLogo() {
        
        if rotate {
            UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
                self.logoView.transform = self.logoView.transform.rotated(by: CGFloat(Double.pi))
            }, completion: { (complete) in
                self.rotateLogo()
            })
        }
    }
    
    func formatSplashScreen(loading: Bool) {
        spinner.isHidden = !loading
        loadingLabel.isHidden = !loading
        if loading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        
   }

}
