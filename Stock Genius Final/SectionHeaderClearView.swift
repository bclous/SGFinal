//
//  SectionHeaderClearView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/8/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum SectionHeaderButton {
    case left
    case right
}

protocol SectionHeaderClearViewDelegate : class {
    func sectionHeaderButtonTapped(_ button: SectionHeaderButton)
}

class SectionHeaderClearView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    weak var delegate : SectionHeaderClearViewDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SectionHeaderClearView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }
    
    public func formatForCurrentPicks() {
        leftButton.isEnabled = false
        rightButton.isEnabled = true
    }

    @IBAction func rightButtonTapped(_ sender: Any) {
        delegate?.sectionHeaderButtonTapped(.right)
    }

    @IBAction func leftButtonTapped(_ sender: Any) {
        delegate?.sectionHeaderButtonTapped(.left)
    }
}
