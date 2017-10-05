//
//  TrendingStockIndividualView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TrendingStockIndividualView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TrendingStockIndividualView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = UIColor.clear
        tickerLabel.textColor = SGConstants.fontColorWhitePrimary
        priceLabel.textColor = SGConstants.fontColorWhitePrimary
        priceChangeLabel.textColor = SGConstants.fontColorWhiteSecondary
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 1
    }
    
    public func formatViewWithStock(_ stock: CurrentStock) {
        
        tickerLabel.text = stock.ticker
        priceLabel.text = stock.priceLabelText(decimals: 2)
        priceChangeLabel.text = stock.priceChangeString(isTodayReturn: true, decimalPlaces: 2)
        priceChangeImageView.image = stock.priceChangeImage(isTodayReturn: true)
        backgroundView.layer.borderColor = stock.percentageChangeContainerColor(isTodayReturn: true).cgColor
    }

}
