//
//  ToggleSegmentView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum IndividualSegmentType : Int {
    case today = 0
    case sinceStartDate = 1
    case oneWeek = 2
    case oneMonth = 3
    case threeMonths = 4
    case sixMonths = 5
    case oneYear = 6
    case threeYears = 7
    case fiveYears = 8
}

protocol IndividualSegmentDelegate : class {
    func segmentTapped(type: IndividualSegmentType)
}

class ToggleSegmentView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet weak var segmentButton: UIButton!
    var segmentType : IndividualSegmentType = .today
    weak var delegate : IndividualSegmentDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ToggleSegmentView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = SGConstants.mainBlueColor.cgColor
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = SGConstants.mainBlackColor
    }
    
    func formatSegmentViewWithType(_ type: IndividualSegmentType) {
        
        switch type {
        case .today:
            segmentLabel.text = "TODAY"
        case .sinceStartDate:
            segmentLabel.text = "SINCE " + DataStore.shared.currentPortfolio.startDateString()
        case .oneWeek:
            segmentLabel.text = "1W"
        case .oneMonth:
            segmentLabel.text = "1M"
        case .threeMonths:
            segmentLabel.text = "3M"
        case .sixMonths:
            segmentLabel.text = "6M"
        case .oneYear:
            segmentLabel.text = "1Y"
        case .threeYears:
            segmentLabel.text = "3Y"
        case .fiveYears:
            segmentLabel.text = "5Y"
        }
        
        segmentType = type
        
    }
    
    public func formatSegment(chosen: Bool) {
        
        containerView.backgroundColor = chosen ? SGConstants.mainBlueColor : SGConstants.mainBlackColor
        segmentButton.isEnabled = !chosen
    }
    
    @IBAction func segmentButtonTapped(_ sender: Any) {
        
        
        //delegate?.segmentTapped(type: segmentType)
        
    
    }
    
    @IBAction func segmentButtonTappedDown(_ sender: Any) {
        delegate?.segmentTapped(type: segmentType)
    }

}
