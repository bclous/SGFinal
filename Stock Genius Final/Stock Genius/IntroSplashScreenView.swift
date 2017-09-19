//
//  IntroSplashScreenView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/16/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol IntroSplashScreenDelegate {
    func splashScreenAnimationComplete()
}

class IntroSplashScreenView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopLayoutConstraint: NSLayoutConstraint!
    var delegate : IntroSplashScreenDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IntroSplashScreenView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }
    
    public func adjustLogoToTop(animate: Bool) {
    
        logoCenterYConstraint.isActive = false
        logoWidthConstraint.constant = 40
        logoTopLayoutConstraint.isActive = true
        
        let duration = animate ? 0.5 : 0
        
        UIView.animate(withDuration: duration, delay: 1.8, options: [], animations: {
            self.layoutIfNeeded()
        }) { (complete) in
            self.delegate?.splashScreenAnimationComplete()
        }
    }

}
