//
//  GirlView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/12/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class GirlView: UIView {

    @IBOutlet var contentView: UIView!
    var topToTopConstraint : NSLayoutConstraint?
    var topToBottomConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GirlView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        loadGirlImage()
        
    }
    
    func loadGirlImage() {
        let girlImage = UIImageView(image: UIImage(named: "girl"))
        self.addSubview(girlImage)
        girlImage.translatesAutoresizingMaskIntoConstraints = false
        girlImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        girlImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        girlImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        topToTopConstraint = girlImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        topToBottomConstraint = girlImage.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        
        topToBottomConstraint?.isActive = true
        topToTopConstraint?.isActive = false
    }
    
    public func animateGirlImage(completion: @escaping () -> ()) {
        
        topToBottomConstraint?.isActive = false
        topToTopConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { (complete) in
            completion()
        }
    
        
    }

}
