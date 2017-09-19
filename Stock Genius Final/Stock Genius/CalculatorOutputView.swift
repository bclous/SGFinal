//
//  CalculatorOutputView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/20/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CalculatorOutputView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var dollarPxLabel: UILabel!
    @IBOutlet weak var numberOfSharesLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    let numberFormatter = NumberFormatter()
    
    var calculatorHolding = CalculatorHolding()
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CalculatorOutputView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func adjustForRemainingCash() {
        // do stuff
        
    }
    
    func update() {
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        tickerLabel.text = calculatorHolding.holding?.ticker!
        
        if let dollarPrice = calculatorHolding.holding?.adjPxCurrent {
            dollarPxLabel.text = String(format:"%.2f",(dollarPrice))
        } else {
            dollarPxLabel.text = "-"
        }
        
        if let shares = numberFormatter.string(from: NSNumber(value: Int(calculatorHolding.numberOfShares))) {
            numberOfSharesLabel.text = shares
        }

        if let number = numberFormatter.string(from: NSNumber(value: Int(calculatorHolding.totalMoneyInvested))) {
            totalMoneyLabel.text = "$ " + number
        }

    }

}
