//
//  CalculatorInputView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/19/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol CalculatorInputDelegate : class {
    func numberTapped(_ number: Int)
    func clearTapped()
    func calculateTapped()
}

class CalculatorInputView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var masterStackView: UIStackView!
    @IBOutlet var inputStackViews: [UIStackView]!
    @IBOutlet weak var calculateButton: UIButton!
    weak var delegate : CalculatorInputDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CalculatorInputView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        formatCalculator()
    }
    
    func formatCalculator(readyToCalculate: Bool) {
        calculateButton.isEnabled = readyToCalculate
        calculateButton.alpha = readyToCalculate ? 1 : 0.5
    }
    
    func formatCalculator() {
        for stackView in inputStackViews {
            let views = stackView.arrangedSubviews
            for view in views {
                let subviews = view.subviews
                for subview in subviews {
                    if subview is UILabel {
                        formatLabel(label: subview as! UILabel)
                    } else {
                        formatBackGroundView(view: subview)
                    }
                }
            }
        }
        
        calculateButton.backgroundColor = SGConstants.mainBlueColor
    }
    
    func formatBackGroundView(view: UIView) {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 0
        view.alpha = 0.2
    }
    
    func formatLabel(label: UILabel) {
       label.alpha = 0.8
    }
    
    func adjustViewForTouchDown(_ view: UIView) {
        let backgroundView = backgroundViewforView(view)
        
        if let bgView = backgroundView {
            bgView.alpha = 0.8
        }
    }
    
    func adjustViewforTouchUp(_ view: UIView) {
        let backgroundView = backgroundViewforView(view)
        
        if let bgView = backgroundView {
            bgView.alpha = 0.2
        }
    }
    
    @IBAction func buttonTouchedDown(_ sender: UIButton) {
        let tag = sender.tag
        let viewFromTag = viewForTag(tag)
        
        if let view = viewFromTag {
            adjustViewForTouchDown(view)
        }
    }
    
    @IBAction func buttonTouchedUp(_ sender: UIButton) {
        let tag = sender.tag
        let viewFromTag = viewForTag(tag)
        
        if let view = viewFromTag {
            adjustViewforTouchUp(view)
        }
        
        if tag == 99 {
            delegate?.clearTapped()
        } else {
            delegate?.numberTapped(tag)
        }
        
    }
    @IBAction func calculateTapped(_ sender: Any) {
        delegate?.calculateTapped()
    }
    
    func viewForTag(_ tag: Int) -> UIView? {
        for stackView in inputStackViews {
            let views = stackView.arrangedSubviews
            for view in views {
                if view.tag == tag {
                    return view
                }
            }
        }
        return nil
    }
    
    func backgroundViewforView(_ view: UIView) -> UIView?{
        let subviews = view.subviews
        for subview in subviews {
            guard subview is UILabel else { return subview }
        }
        
        return nil
    }
    
    func labelForView(_ view: UIView) -> UILabel? {
        let subviews = view.subviews
        for subview in subviews {
            if subview is UILabel {
                return subview as? UILabel
            }
        }
        
        return nil
    }
    

}
