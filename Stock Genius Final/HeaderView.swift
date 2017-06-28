//
//  HeaderView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var adjustableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var adjustableContainerView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var seperatorView: UIView!
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        secondaryLabel.textColor = SGConstants.fontColorWhiteSecondary
        contentView.backgroundColor = SGConstants.mainBlackColor

    }
    
    public func adjustHeaderViewForOffset(_ offset: CGFloat) {
        
        if offset >= 0 && offset <= 60 {
            
            if offset <= 20 {
                let percentage : CGFloat = 1.0 - offset / 20.0
                secondaryLabel.alpha = percentage
            } else {
                secondaryLabel.alpha = 0
            }
            
            adjustableViewBottomConstraint.constant = offset
            mainLabelTopConstraint.constant = 45.0 - (offset / 2.0)
            
            let fontPercentage :CGFloat = offset / 60.0
            let fontSize : CGFloat = 36.0 - (21.0 * fontPercentage)
            
            mainLabel.font = mainLabel.font.withSize(fontSize)
            
        } else if offset < 0 {
            mainLabel.font = mainLabel.font.withSize(36.0)
            secondaryLabel.alpha = 1
            adjustableViewBottomConstraint.constant = 0
            mainLabelTopConstraint.constant = 45
        } else {
            mainLabel.font = mainLabel.font.withSize(15.0)
            secondaryLabel.alpha = 0
            adjustableViewBottomConstraint.constant = 60
            mainLabelTopConstraint.constant = 15
        }
        
        layoutIfNeeded()
        
    }


}
