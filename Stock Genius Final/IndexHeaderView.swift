//
//  IndexHeaderView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class IndexHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftIndexView: IndexHeaderSection!
    @IBOutlet weak var rightIndexView: IndexHeaderSection!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndexHeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        
    }
    
    public func formatViewWithIndices(leftIndex: CurrentStock, rightIndex: CurrentStock) {
        leftIndexView.formatViewWithStock(leftIndex, name: "S&P 500")
        rightIndexView.formatViewWithStock(rightIndex, name: "DJIA")
    }
    
    public func refreshView() {
        leftIndexView.refreshView()
        rightIndexView.refreshView()
    }

}
