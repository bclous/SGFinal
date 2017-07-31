//
//  ShareCalcHeaderView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol CalcHeaderViewDelegate : class {
    func userTapped()
}

class ShareCalcHeaderView: UIView {

    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var portfolioAmountLabel: UILabel!
    @IBOutlet var contentView: UIView!
    weak var delegate : CalcHeaderViewDelegate?
    let max = 999999999
    var currentPortfolioAmount = 15000
    let numberFormatter = NumberFormatter()
    var minimumString = ""
    var minimum = 15000
    var cachedPortfolioAmount = 15000
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ShareCalcHeader", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
    }
    
    @IBAction func userTapped(_ sender: Any) {
        delegate?.userTapped()
    }
    
    public func formatViewWithNumber(_ number: Int) {
        let newAmount = currentPortfolioAmount * 10 + number
        if newAmount <= max {
            currentPortfolioAmount = newAmount
            adjustLabel()
        }
        
    }
    
    public func formatViewWithInvestmentAmount(_ amount: Int, minimum: Int) {
       self.minimum = minimum
        if let minString = numberFormatter.string(from: NSNumber(value: minimum)) {
            minimumString = "Minimum: $ " + minString
        }
        minimumLabel.text = minimumString
        currentPortfolioAmount = amount
        cachedPortfolioAmount = amount
        adjustLabel()
    }
    
    public func resetView() {
        currentPortfolioAmount = 0
        adjustLabel()
    }
    
    private func adjustLabel() {
        if let number = numberFormatter.string(from: NSNumber(value: currentPortfolioAmount)) {
            portfolioAmountLabel.text = "$ " + number
        }
        
        minimumLabel.isHidden = currentPortfolioAmount >= minimum
        
    }
    
    public func isReadyToCalculate() -> Bool {
        return currentPortfolioAmount >= minimum
    }
    
    public func cacheNewPortfolioAmount() {
        cachedPortfolioAmount = currentPortfolioAmount
    }
    
    public func resetToCachedPortfolioAmount() {
        currentPortfolioAmount = cachedPortfolioAmount
        adjustLabel()
    }
    


}
