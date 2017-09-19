//
//  PastHoldingsHeaderView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastHoldingsHeaderView: UIView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
        Bundle.main.loadNibNamed("PastHoldingsHeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.offBlackColor
        
        nameLabel.textColor = SGConstants.mainBlueColor
    }


}
