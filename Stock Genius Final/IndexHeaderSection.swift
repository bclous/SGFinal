//
//  IndexHeaderSection.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IndexHeaderSection: UIView {

    @IBOutlet weak var indexNameLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    var stock : CurrentStock?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndexHeaderSection", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        indexNameLabel.textColor = SGConstants.fontColorWhitePrimary
        percentageChangeLabel.textColor = SGConstants.fontColorWhitePrimary
        priceLabel.textColor = SGConstants.fontColorWhiteSecondary
        priceChangeLabel.textColor = SGConstants.fontColorWhiteSecondary
        contentView.backgroundColor = SGConstants.mainBlackColor

    }
    
    public func formatViewWithStock(_ stock: CurrentStock, name: String) {
        self.stock = stock
        indexNameLabel.text = name
        percentageChangeLabel.text = stock.percentageChangeDirectionString(isTodayReturn: true) + stock.percentageChangeString(isTodayReturn: true, decimalPlaces: 1)
        priceLabel.text = stock.priceLabelText(decimals: 2)
        priceChangeLabel.text = stock.priceChangeString(isTodayReturn: true, decimalPlaces: 2)
        priceChangeImageView.image = stock.priceDirectionImage(isTodayReturn: true)
    }
    
    public func refreshView() {
        if let stock = stock {
            percentageChangeLabel.text = stock.percentageChangeDirectionString(isTodayReturn: true) + stock.percentageChangeString(isTodayReturn: true, decimalPlaces: 1)
            priceLabel.text = stock.priceLabelText(decimals: 2)
            priceChangeLabel.text = stock.priceChangeString(isTodayReturn: true, decimalPlaces: 2)
            priceChangeImageView.image = stock.priceDirectionImage(isTodayReturn: true)
        }
    }

}
