//
//  PastPerformanceGraphView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPerformanceGraphView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indexReturnLabel: UILabel!
    @IBOutlet weak var SGReturnLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indexWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sgGraphBar: UIView!
    @IBOutlet weak var indexGraphBar: UIView!
    @IBOutlet weak var leftMarginView: UIView!
    
    var sgPercentage : Float = 100
    var indexPercentage : Float = 75
    var frameWidth : Float = 375
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PastPerformanceGraphView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        sgGraphBar.layer.cornerRadius = 20
        sgGraphBar.backgroundColor = SGConstants.mainBlueColor
        sgGraphBar.alpha = 1
        indexGraphBar.layer.cornerRadius = 20
        contentView.backgroundColor = SGConstants.offBlackColor
        leftMarginView.backgroundColor = SGConstants.offBlackColor
        
        
    }
    
    public func adjustGraph(toFullAmount: Bool, animated: Bool) {
        
        let containerWidth : Float = frameWidth - 40.0
        
        let sgMultiplier = sgPercentage >= indexPercentage ? 1.0 : sgPercentage / indexPercentage
        let indexMultiplier = indexPercentage >= sgPercentage ? 1.0 : indexPercentage / sgPercentage
        let sgConstant = sgMultiplier * containerWidth
        let indexConstant = indexMultiplier * containerWidth
        
//        sgWidthConstraint.isActive = false
//        indexWidthConstraint.isActive = false
        
        sgWidthConstraint.constant = CGFloat(toFullAmount ? sgConstant : 100.0)
        indexWidthConstraint.constant = CGFloat(toFullAmount ? indexConstant : 100.0)
        
        sgWidthConstraint.isActive = true
        indexWidthConstraint.isActive = true
        
        let duration = animated ? 0.2 : 0
        
        UIView.animate(withDuration: duration, animations: { 
            self.layoutIfNeeded()
        }) { (complete) in
            // complete
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        adjustGraph(toFullAmount: true, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustGraph(toFullAmount: true, animated: false)
    }
    
}
