//
//  IntroSplashScreen.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/12/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IntroSplashScreen: UIView {

    @IBOutlet var contentView: UIView!
    var centerYConstraint : NSLayoutConstraint?
    var topConstraint : NSLayoutConstraint?
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IntroSplashScreen", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.backgroundColor = SGConstants.mainBlackColor
        addImage()
    
    }
    
    func addImage() {
        let logoImage = UIImageView(image: UIImage(named: "Logo"))
        self.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        widthConstraint = logoImage.widthAnchor.constraint(equalToConstant: 100)
        logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 1).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        centerYConstraint = logoImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        topConstraint = logoImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
        
        topConstraint?.isActive = false
        widthConstraint?.isActive = true
        centerYConstraint?.isActive = true
        
        
    }
    
    func animateLogoToTop(completion: @escaping () -> ()) {
        
        self.centerYConstraint?.isActive = false
        self.topConstraint?.isActive = true
        self.widthConstraint?.constant = 50
        
        UIView.animate(withDuration: 0.4, delay: 1.4, options: [], animations: {
            self.layoutIfNeeded()
        }) { (complete) in
            completion()
        }
    }

}
