//
//  MainHoldingsHeaderBubbleView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class MainHoldingsHeaderBubbleView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bubbleContainerView: UIView!
    @IBOutlet weak var currentPicksIdentifiedLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var darkView: UIView!
    
    var positiveStocks = 8
    var height : CGFloat = 140
    var width : CGFloat = 375
    var radius : CGFloat = 50
    var bubbles : [UIView] = []
    var fastMode = false
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MainHoldingsHeaderBubbleView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        darkView.backgroundColor = SGConstants.offBlackColor
      
    }
    
    func resetFrame(height: CGFloat, width: CGFloat) {
        self.width = width
        self.height = height
    }
    
    func createBubbles() {
    
        for _ in 0...30 {
            let bubbleView = UIView(frame: randomCGRect())
            bubbleView.layer.cornerRadius = radius
            bubbleContainerView.addSubview(bubbleView)
            bubbles.append(bubbleView)
            bubbleView.alpha = 0.5
        }
        
        formatBubbleColors()
    }
    
    func animateBubbles() {
        for bubbleView in bubbles {
            animateBubble(bubbleView)
        }
    }
    
    func animateBubble(_ bubbleView: UIView) {
       
        let duration = fastMode ? 0.2 : randomDuration(min: 2, max: 4)
        
        UIView.animate(withDuration: duration, animations: {
        bubbleView.frame = self.randomCGRect()
       }) { (complete) in
        self.animateBubble(bubbleView)
        }
    }
    
    func formatBubbleColors() {
        for index in 0...9 {
            bubbles[index].backgroundColor = SGConstants.mainBlueColor
        }
    }
    
    func showBubbles(on: Bool) {
        for index in 0...9 {
            bubbles[index].alpha = on ? 1 : 0
        }
    }
    
    func randomCGRect() -> CGRect {
        return CGRect(x: randomWithMax(Int(width)-50), y: randomWithMax(Int(height)-50), width: radius*2, height: radius*2)
    }
    
    func randomWithMax(_ max: Int) -> CGFloat {
        let random = arc4random_uniform(UInt32(max))
        return CGFloat(random)
    }
    
    func randomDuration(min: Int, max: Int) -> Double {
        let random = arc4random_uniform(UInt32(max - min))
        let final = Int(random) + min
        return Double(final)
    }


}
