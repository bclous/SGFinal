//
//  UpDownButtonsView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/30/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol UpDownButtonDelegate : class {
    func directionTapped(isUp: Bool)
}

class UpDownButtonsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    weak var delegate : UpDownButtonDelegate?
    
    public var buttonsAreActive : Bool = false {
        didSet {
            upButton.isEnabled = buttonsAreActive
            downButton.isEnabled = buttonsAreActive
        }
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UpDownButtonsView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        

    }

    @IBAction func upButtonTapped(_ sender: Any) {
        delegate?.directionTapped(isUp: true)
    }
    
    @IBAction func downButtonTapped(_ sender: Any) {
        delegate?.directionTapped(isUp: false)
    }
    
    
    
}
