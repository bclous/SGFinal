//
//  SGLabels.swift
//  Stock Genius
//
//  Created by Brian Clouser on 6/24/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import Foundation
import UIKit

class SGLabel1 : UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.textColor = UIColor.red
        self.alpha = 0.9
    }
    
}
