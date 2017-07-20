//
//  CircleTabView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/14/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class CircleTabView: UIView {

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    private var currentIndex = 9
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CircleTabView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        formatCircleFrames()
        formatCircleViewForIndex(0)

    }
    
    public func formatCircleViewForOffset(_ offset: CGPoint, frameWidth: CGFloat) {
        
        let adjustedOffset = offset.x - frameWidth < 0 ? 0.0 : offset.x - frameWidth
        let index = Int(round(adjustedOffset / frameWidth))
        formatCircleViewForIndex(index)
    }
    
    private func formatCircleViewForIndex(_ index: Int) {
        
        if index != currentIndex { 
            var count = 0
            
            for circleView in mainStackView.arrangedSubviews {
                circleView.backgroundColor = index == count ? SGConstants.mainBlueColor : UIColor.white
                circleView.alpha = index == count ? 1.0 : 0.2
                count += 1
            }
            
            currentIndex = index
        }
    
    }
    
    private func formatCircleFrames() {
        for circleView in mainStackView.arrangedSubviews {
            circleView.layer.cornerRadius = 6
        }
    }

}
