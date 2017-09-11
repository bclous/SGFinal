//
//  IndividualPerformanceViewSegment.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IndividualPerformanceViewSegment: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var percentageChangeContainerView: UIView!
    @IBOutlet weak var percentageChangeSuppView: UIView!

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndividualPerformanceViewSegment", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        
        containerView.layer.cornerRadius = 5
        percentageChangeContainerView.layer.cornerRadius = 5
        percentageChangeContainerView.backgroundColor = SGConstants.mainGreenColor
        percentageChangeSuppView.backgroundColor = SGConstants.mainGreenColor
        
    }
    
    public func formatViewForPercentageChange(_ change: Float) {
        percentageChangeContainerView.backgroundColor = change >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        percentageChangeSuppView.backgroundColor = change >= 0 ? SGConstants.mainGreenColor : SGConstants.mainRedColor
        
        
    }

}