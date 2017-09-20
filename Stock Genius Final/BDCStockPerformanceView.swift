//
//  BDCStockPerformanceView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/15/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum GraphDisplayType {
    case dataAvailable
    case retrievingData
    case failedToRetrieveTryAgain
}

class BDCStockPerformanceView: UIView, IndividualToggleViewDelegate {
    
    var stock : CurrentStock?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var unableToConectLabel: UILabel!
    @IBOutlet weak var unableToConnectView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var retrievingView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var toggleView: IndividualToggleView!
    @IBOutlet weak var chartView: BDCStockChart!
    var currentToggleChoice: IndividualSegmentType = .sixMonths
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BDCStockPerformanceView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        toggleView.delegate = self
        
        formatUnableToConect()
        formatRetrievingView()
        
    }
    
    private func formatUnableToConect() {
        
        unableToConnectView.backgroundColor = SGConstants.mainBlackColor
        unableToConectLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        tryAgainButton.backgroundColor = SGConstants.mainBlueColor
        tryAgainButton.layer.cornerRadius = 15
        tryAgainButton.setTitleColor(UIColor.white, for: .normal)
        unableToConnectView.isHidden = true
    }
    
    private func formatRetrievingView() {
        retrievingView.backgroundColor = SGConstants.mainBlackColor
        spinner.startAnimating()
        retrievingView.isHidden = true
        
    }
    
    
    public func formatGraphForStock(_ stock: CurrentStock, durationType: IndividualSegmentType) {
        
        self.stock = stock
        toggleView.formatToggleViewForType(durationType)
        
        let haveData = durationType == .today ? !stock.dailyHistory.isEmpty : !stock.graphHistory.isEmpty
        
        if haveData {
            self.chartView.formatChartWithData(stock.graphDataForDuration(durationType), isDaily: durationType == .today)
        } else {
            self.formatViewForGraphDisplayType(.retrievingData)
            if durationType == .today {
                stock.pullDailyGraphData(completion: { (success) in
                    if success {
                        self.chartView.formatChartWithData(stock.graphDataForDuration(durationType), isDaily: true)
                        self.formatViewForGraphDisplayType(.dataAvailable)
                    } else {
                        self.formatViewForGraphDisplayType(.failedToRetrieveTryAgain)
                    }
                })
            } else {
                stock.pullGraphData(completion: { (success) in
                    if success {
                        self.chartView.formatChartWithData(stock.graphDataForDuration(durationType), isDaily: false)
                        self.formatViewForGraphDisplayType(.dataAvailable)
                    } else {
                        self.formatViewForGraphDisplayType(.failedToRetrieveTryAgain)
                    }
                })
            }

        }
    }
    
    internal func toggleChosen(type: IndividualSegmentType) {
        
        currentToggleChoice = type
        
        if let stock = stock {
            stock.lastToggleSegment = type
            formatGraphForStock(stock, durationType: type)
        }
    }

    
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        
        if let stock = stock {
            formatGraphForStock(stock, durationType: currentToggleChoice)
        }
        
    }
    
    private func formatViewForGraphDisplayType(_ type: GraphDisplayType) {
        
        switch type {
        case .dataAvailable:
            retrievingView.isHidden = true
            unableToConnectView.isHidden = true
        case .retrievingData:
            unableToConnectView.isHidden = true
            retrievingView.isHidden = false
        case .failedToRetrieveTryAgain:
            retrievingView.isHidden = true
            unableToConnectView.isHidden = false
        }
        
    }
    
}


