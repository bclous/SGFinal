//
//  IndividualHeaderView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/28/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IndividualHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var adjustableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeImage: UIImageView!
    @IBOutlet weak var backButtonHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndividualHeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        
        
    }
    
    func adjustIndividualHeaderViewForOffset(_ offset: CGFloat) {
        
        if offset >= 0 && offset <= 60 {
            
            if offset <= 20 {
                let percentage : CGFloat = 1.0 - offset / 20.0
                secondaryLabel.alpha = percentage
                priceChangeLabel.alpha = percentage
                priceChangeImage.alpha = percentage
            } else {
                secondaryLabel.alpha = 0
                priceChangeLabel.alpha = 0
                priceChangeImage.alpha = 0
            }
            
            adjustableViewBottomConstraint.constant = offset
            mainLabelTopConstraint.constant = 45.0 - (offset / 2.0)
            
            let fontPercentage :CGFloat = offset / 60.0
            let mainfontSize : CGFloat = 36.0 - (21.0 * fontPercentage)
            let priceChangeFontSize : CGFloat = 29.0 - (14.0 * fontPercentage)
            
            mainLabel.font = mainLabel.font.withSize(mainfontSize)
            priceLabel.font = priceLabel.font.withSize(priceChangeFontSize)
            
        } else if offset < 0 {
            mainLabel.font = mainLabel.font.withSize(36.0)
            priceLabel.font = priceLabel.font.withSize(29.0)
            secondaryLabel.alpha = 1
            priceChangeImage.alpha = 1
            priceChangeLabel.alpha = 1
            adjustableViewBottomConstraint.constant = 0
            mainLabelTopConstraint.constant = 45
        } else {
            mainLabel.font = mainLabel.font.withSize(15.0)
            priceLabel.font = priceLabel.font.withSize(15.0)
            secondaryLabel.alpha = 0
            priceChangeLabel.alpha = 0
            priceChangeImage.alpha = 0
            adjustableViewBottomConstraint.constant = 60
            mainLabelTopConstraint.constant = 15
        }
        
        layoutIfNeeded()

        
    }


}
