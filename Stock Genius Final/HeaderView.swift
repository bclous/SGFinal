//
//  HeaderView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate : class {
    func refreshButtonTapped()
}

class HeaderView: UIView {

    @IBOutlet weak var adjustableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var adjustableContainerView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshImage: UIImageView!
    var shouldAnimate = false
    weak var delegate : HeaderViewDelegate?
    var maxRefreshImageAlpha : CGFloat = 0.9
    var showRefreshBar = false
    
    @IBOutlet weak var seperatorView: UIView!
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        secondaryLabel.textColor = SGConstants.fontColorWhiteSecondary
        contentView.backgroundColor = SGConstants.mainBlackColor
       
        
    }
    
    public func adjustHeaderViewForOffset(_ offset: CGFloat) {
        
        if offset >= 0 && offset <= 60 {
            refreshButton.isEnabled = offset == 0
            if offset <= 20 {
                let percentage : CGFloat = 1.0 - offset / 20.0
                secondaryLabel.alpha = percentage
                refreshImage.alpha = showRefreshBar ? percentage * maxRefreshImageAlpha : 0
            } else {
                secondaryLabel.alpha = 0
            }
            
            adjustableViewBottomConstraint.constant = offset
            mainLabelTopConstraint.constant = 45.0 - (offset / 2.0)
            
            let fontPercentage :CGFloat = offset / 60.0
            let fontSize : CGFloat = 36.0 - (21.0 * fontPercentage)
            
            mainLabel.font = mainLabel.font.withSize(fontSize)
            
        } else if offset < 0 {
            refreshButton.isEnabled = showRefreshBar
            refreshImage.alpha = showRefreshBar ? maxRefreshImageAlpha : 0
            mainLabel.font = mainLabel.font.withSize(36.0)
            secondaryLabel.alpha = 1
            adjustableViewBottomConstraint.constant = 0
            mainLabelTopConstraint.constant = 45
        } else {
            refreshButton.isEnabled = false
            mainLabel.font = mainLabel.font.withSize(15.0)
            secondaryLabel.alpha = 0
            refreshImage.alpha = 0
            adjustableViewBottomConstraint.constant = 60
            mainLabelTopConstraint.constant = 15
        }
        
        layoutIfNeeded()
  
    }
    
    public func formatHeaderViewForVC(_ type: TabBarChoice) {
        
        switch type {
        case .currentPicks:
            
            let headerDateString = DataStore.shared.currentPortfolio.startDateString()
            secondaryLabel.text = "Identified from 13-F data on \(headerDateString)"
            mainLabel.text = "Current Picks"
            refreshButton.isEnabled = true
            refreshImage.alpha = 0.9
            showRefreshBar = true
        case .calculator:
            mainLabel.text = "Share Calculator"
            secondaryLabel.text = "Tap to edit investment amount"
            refreshButton.isEnabled = false
            refreshImage.alpha = 0
            showRefreshBar = false
        case .pastPicks:
            mainLabel.text = "Past Picks"
            secondaryLabel.text = DataStore.shared.pastPortfoliosString()
            refreshButton.isEnabled = false
            refreshImage.alpha = 0
            showRefreshBar = false
        case .watchlist:
            secondaryLabel.text = "Last Price Update: Today: 9:00 AM"
            mainLabel.text = "Watchlist"
            refreshButton.isEnabled = true
            refreshImage.alpha = 0.9
            refreshImage.image = UIImage(named: "ic_add_white")
            showRefreshBar = true
        }
        
        
    }
    
    public func startCurrentPicksPriceRefresh() {
        
        maxRefreshImageAlpha = 0.4
        refreshImage.alpha = maxRefreshImageAlpha
        shouldAnimate = true
        refreshButton.isEnabled = false
        rotateView(targetView: refreshImage, duration: 0.25, delay: 0.25, shouldAnimate: shouldAnimate)
    }
    
    public func priceRefreshFinished() {
        layer.removeAllAnimations()
        maxRefreshImageAlpha = 0.9
        refreshImage.alpha = 0.9
        shouldAnimate = false
        refreshButton.isEnabled = true
    }
    
    private func rotateView(targetView: UIView, duration: Double, delay: Double, shouldAnimate: Bool) {
        
        if !shouldAnimate {
            return
        } else {
            UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
            }) { finished in
                self.rotateView(targetView: targetView, duration: duration, delay: delay, shouldAnimate: self.shouldAnimate )
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        delegate?.refreshButtonTapped()
    }


}
