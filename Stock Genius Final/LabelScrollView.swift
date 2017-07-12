//
//  LabelScrollView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class LabelScrollView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var masterStackView: UIStackView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var titles = ["Gathering 13-F filings...", "Analyzing 13-F data...", "Calculating current stock picks...", "Loading real time prices..."]

    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LabelScrollView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        formatViewWithTitles()
        
    }
    
    private func formatViewWithTitles() {
        
        var index = 0
        for subview in masterStackView.arrangedSubviews {
            let view = subview as! IndividualLabelView
            view.mainLabel.text = titles[index]
            index += 1
        }
    }
    
    public func adjustScrollViewToPage(_ page: Int, animated: Bool) {
        
        let pageOffset = self.frame.width
        let safePage = page > 3 ? 3 : page
        let offset = pageOffset * CGFloat(safePage)
        let point = CGPoint(x: offset, y: 0)
        
        mainScrollView.setContentOffset(point, animated: animated)
        
    }

}
