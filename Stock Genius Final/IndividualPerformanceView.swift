//
//  IndividualPerformanceView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IndividualPerformanceView: UIView {

    @IBOutlet weak var stockView: IndividualPerformanceViewSegment!
    @IBOutlet weak var indexView: IndividualPerformanceViewSegment!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndividualPerformanceView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // change this
        contentView.backgroundColor = SGConstants.mainBlackColor
        
    }
    
    public func formatViewForStocks(_ stocks: (stock: CurrentStock, index: CurrentStock), segmentType: IndividualSegmentType) {
        
        stockView.formatViewForStock(stocks.stock, segmentType: segmentType)
        indexView.formatViewForStock(stocks.index, segmentType: segmentType)
        
    }
    
    public func formatViewForLoadingData() {
        
        stockView.formatViewForLoadingData()
        indexView.formatViewForLoadingData()
    }
    
    
    
    


}
