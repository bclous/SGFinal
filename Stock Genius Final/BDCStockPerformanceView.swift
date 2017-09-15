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
    
    var stocks : (stock : CurrentStock, index: CurrentStock)?
        

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var unableToConectLabel: UILabel!
    @IBOutlet weak var unableToConnectView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var retrievingView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var toggleView: IndividualToggleView!
    @IBOutlet weak var performanceView: IndividualPerformanceView!
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
        formatView()
        
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
    
    public func formatView() {
        
        if let stocks = stocks {
            currentToggleChoice = stocks.stock.lastToggleSegment
            toggleView.formatToggleViewForType(currentToggleChoice)
            chartView.data = stocks.stock.graphDataFromType(currentToggleChoice)
            
            let haveData = haveGraphDataForStock(stocks.stock)
            
            if haveData {
                
                formatViewForGraphDisplayType(.dataAvailable)
                
            } else {
                formatViewForGraphDisplayType(.retrievingData)
                
                AlphaVantageClient.shared.pullPricesForStock(stocks.stock, callType: chartDataTypeFromToggleChoice(), completion: { (success) in
                    
                    if success {
                        DispatchQueue.main.async {self.formatViewForGraphDisplayType(.dataAvailable)}
                    } else {
                        DispatchQueue.main.async {self.formatViewForGraphDisplayType(.failedToRetrieveTryAgain)}
                    }
                    
                })
            }
        }
        
        
        
    }
    
    private func haveGraphDataForStock(_ stock: CurrentStock) -> Bool {
        
         let historyType = chartDataTypeFromToggleChoice()
        
        switch historyType {
        case .intraday:
            return stock.hasShortPriceHistory
        case .shortHistory:
            return stock.hasShortPriceHistory
        case .longHistory:
            return stock.hasLongPriceHistory
        }
    
    }
    
    internal func toggleChosen(type: IndividualSegmentType) {
        currentToggleChoice = type
        
        if let stocks = stocks {
            let stock = stocks.stock
            stock.lastToggleSegment = type
        }
        
        formatView()
    }
    
    private func chartDataTypeFromToggleChoice() -> AlphaVantageCallType {
       
        switch currentToggleChoice {
        case .today:
            return .shortHistory
        case .sinceStartDate:
            return .shortHistory
        case .oneWeek:
            return .shortHistory
        case .oneMonth:
            return .shortHistory
        case .threeMonths:
            return .shortHistory
        case .sixMonths:
            return .longHistory
        case .oneYear:
            return .longHistory
        case .threeYears:
            return .longHistory
        case .fiveYears:
            return .longHistory
        }
    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        
        
    }
    
    private func formatViewForGraphDisplayType(_ type: GraphDisplayType) {
        
        switch type {
        case .dataAvailable:
            retrievingView.isHidden = true
            unableToConnectView.isHidden = true
            formatViewForDataAvailable()
        case .retrievingData:
            unableToConnectView.isHidden = true
            retrievingView.isHidden = false
            performanceView.formatViewForLoadingData()
        case .failedToRetrieveTryAgain:
            retrievingView.isHidden = true
            unableToConnectView.isHidden = false
            performanceView.formatViewForLoadingData()
        }
        
    }
    
    private func formatViewForDataAvailable() {
        if let stocks = stocks {
            performanceView.formatViewForStocks(stocks, segmentType: currentToggleChoice)
        }
    }

}


