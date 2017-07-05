//
//  NextUpdateView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/1/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class NextUpdateView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NextUpdateView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    public func updateViewWithDays(_ days: Int) {
    
        let dayString = days == 1 ? "day" : "days"
        mainLabel.text = "Next pick update: \(days)" + " " + dayString
    }

}
