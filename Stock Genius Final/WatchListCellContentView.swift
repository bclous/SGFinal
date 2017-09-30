//
//  WatchListCellContentView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol WatchCellContentViewDelegate : class {
    func returnToHome()
}

class WatchListCellContentView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeImage: UIImageView!
    @IBOutlet weak var percentageChangeContainerView: UIView!
    @IBOutlet weak var percentageChangePlusMinusLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var returnToHomeButton: UIButton!
    var delegate : WatchCellContentViewDelegate?
    
    var isInEditMode : Bool = false {
        didSet {
            returnToHomeButton.isEnabled = isInEditMode
        }
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WatchListCellContentView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        percentageChangeContainerView.layer.cornerRadius = 10

    }
    
    public func formatViewWithStock(_ stock: CurrentStock) {
        
        tickerLabel.text = stock.ticker
        companyNameLabel.text = stock.companyName
        priceLabel.text = stock.priceLabelText(decimals: 2)
        priceChangeLabel.text = stock.priceChangeString(isTodayReturn: true, decimalPlaces: 2)
        priceChangeImage.image = stock.priceChangeImage(isTodayReturn: true)
        percentageChangeContainerView.backgroundColor = stock.percentageChangeContainerColor(isTodayReturn: true)
        percentageChangePlusMinusLabel.text = stock.percentageChangeDirectionString(isTodayReturn: true)
        percentageChangeLabel.text = stock.percentageChangeString(isTodayReturn: true, decimalPlaces: 1)
    }

    @IBAction func returnToHomeTapped(_ sender: Any) {
        delegate?.returnToHome()
    }
}
