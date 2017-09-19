//
//  HeaderView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/17/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func menuButtonTapped(sender: FunctionVC)
}

class HeaderView: UIView {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var pastHoldingsLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pastHoldingsCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var calculatorTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pastHoldingsWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var calculatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var calculatorCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var pastHoldingsLogo: UIImageView!
    @IBOutlet weak var calculatorLogo: UIImageView!
    @IBOutlet weak var bottomBorderView: UIView!
    
    @IBOutlet var contentView: UIView!
    weak var delegate: HeaderViewDelegate?
    var currentView : FunctionVC = .mainHoldings
    
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
        mainLabel.alpha = 0
    }
    
    func adjustHeaderViewto(_ newFunction: FunctionVC) {
        
        delegate?.menuButtonTapped(sender: newFunction)
        let smallSize : CGFloat = 30
        let largeSize : CGFloat = 40
        let animationLength = 0.2
        
        if newFunction == .pastHoldings {
            mainLabel.text = "PAST PICKS"
        }
        
        if newFunction == .calculator {
            mainLabel.text = "SHARE CALCULATOR"
        }
        
        isUserInteractionEnabled = false
        turnAllConstraintsOff()
        calculatorCenterConstraint.isActive = newFunction == .calculator ? true : false
        pastHoldingsCenterConstraint.isActive = newFunction == .pastHoldings ? true : false
        calculatorTrailingConstraint.isActive = newFunction == .calculator ? false : true
        pastHoldingsLeadingConstraint.isActive = newFunction == .pastHoldings ? false : true
        mainCenterConstraint.isActive = newFunction == .mainHoldings ? true : false
        mainLeadingConstraint.isActive = newFunction == .calculator ? true : false
        mainTrailingConstraint.isActive = newFunction == .pastHoldings ? true : false
        calculatorWidthConstraint.constant = newFunction == .calculator ? largeSize : smallSize
        mainWidthConstraint.constant = newFunction == .mainHoldings ? largeSize : smallSize
        pastHoldingsWidthConstraint.constant = newFunction == .pastHoldings ? largeSize : smallSize
   
        UIView.animate(withDuration: animationLength, animations: {
            self.calculatorLogo.alpha = newFunction == .mainHoldings ? 1 : 0
            self.pastHoldingsLogo.alpha = newFunction == .mainHoldings ? 1 : 0
            self.mainLabel.alpha = newFunction == .mainHoldings ? 0 : 1
            self.layoutIfNeeded()
        }) { (complete) in
            self.isUserInteractionEnabled = true
            self.currentView = newFunction
            self.leftButton.isEnabled = newFunction == .pastHoldings ? false : true
            self.rightButton.isEnabled = newFunction == .calculator ? false : true
            //self.bottomBorderView.alpha = newFunction == .mainHoldings ? 0 : 1
        }
    }
    
    func turnAllConstraintsOff() {
        self.mainLeadingConstraint.isActive = false
        self.mainTrailingConstraint.isActive = false
        self.calculatorCenterConstraint.isActive = false
        self.pastHoldingsCenterConstraint.isActive = false
        self.mainCenterConstraint.isActive = false
        self.pastHoldingsLeadingConstraint.isActive = false
        self.calculatorTrailingConstraint.isActive = false
    }
    
    @IBAction func pastHoldingsTapped(_ sender: Any) {
        adjustHeaderViewto(.pastHoldings)
        delegate?.menuButtonTapped(sender: .pastHoldings)
    }
    
    @IBAction func mainHoldingsTapped(_ sender: Any) {
        adjustHeaderViewto(.mainHoldings)
        delegate?.menuButtonTapped(sender: .mainHoldings)
    }

    @IBAction func calculatorTapped(_ sender: Any) {
        adjustHeaderViewto(.calculator)
        delegate?.menuButtonTapped(sender: .calculator)
    }

    @IBAction func leftButtonTapped(_ sender: Any) {
        switch currentView {
        case .mainHoldings:
            adjustHeaderViewto(.pastHoldings)
        case .pastHoldings:
            return
        case .calculator:
            adjustHeaderViewto(.mainHoldings)
        }
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        switch currentView {
        case .mainHoldings:
            adjustHeaderViewto(.calculator)
        case .pastHoldings:
            adjustHeaderViewto(.mainHoldings)
        case .calculator:
            return
        }
    }
    

}
