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
        stockLabel.text = "-"
        percentageChangeLabel.text = "-"
        percentageChangeContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
    }
    
    public func formatViewForStock(_ stock: CurrentStock, segmentType: IndividualSegmentType, noEarlierThan date: Date?) {
        stockLabel.text = stock.ticker == "SPY" ? "S&P 500 Index" : stock.ticker
        let values = stock.performanceInfoFromType(segmentType, noEarlierThan: date)
        percentageChangeLabel.text = values.return
        percentageChangeContainerView.backgroundColor = values.color
        percentageChangeSuppView.backgroundColor = values.color
        
    }
    
    public func formatViewForLoadingData() {
        percentageChangeLabel.text = "-"
        percentageChangeContainerView.backgroundColor = SGConstants.mainGreenColor
        percentageChangeSuppView.backgroundColor = SGConstants.mainGreenColor
    }

}
