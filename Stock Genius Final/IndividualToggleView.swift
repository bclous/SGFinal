//
//  IndividualToggleView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol IndividualToggleViewDelegate : class {
    func toggleChosen(type: IndividualSegmentType)
}

class IndividualToggleView: UIView, IndividualSegmentDelegate {

    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    var toggleSegments : [ToggleSegmentView] = []
    weak var delegate : IndividualToggleViewDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("IndividualToggleView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        formatToggleView()
        
    }
    
    func formatToggleView() {
        
        var index = 2
        for subview in bottomStackView.arrangedSubviews {
            let segmentView = subview as! ToggleSegmentView
            segmentView.delegate = self
            toggleSegments.append(segmentView)
            segmentView.formatSegmentViewWithType(IndividualSegmentType(rawValue: index)!)
            index += 1
        }
        
        var idx = 0
        for subview in topStackView.arrangedSubviews {
            let segmentView = subview as! ToggleSegmentView
            toggleSegments.append(segmentView)
            segmentView.delegate = self
            segmentView.formatSegmentViewWithType(IndividualSegmentType(rawValue: idx)!)
            idx += 1
        }
    }
    
    func formatToggleViewForType(_ type: IndividualSegmentType) {
        for view in toggleSegments {
            let chosen = type == view.segmentType
            view.formatSegment(chosen: chosen)
        }
    }
    
    func segmentTapped(type: IndividualSegmentType) {
        
        for view in toggleSegments {
            let chosen = type == view.segmentType
            view.formatSegment(chosen: chosen)
            delegate?.toggleChosen(type: type)
        }
        
    }

}
