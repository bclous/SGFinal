//
//  Page5.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/8/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol Page5Delegate {
    func getStartedTapped()
    func restorePurchaseTapped()
    func termsTapped()
}

class Page5: UIView {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet var contentView: UIView!
    var delegate : Page5Delegate?
    
    @IBOutlet weak var disclaimerLabel: UILabel!

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Page5", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        getStartedButton.backgroundColor = SGConstants.mainBlueColor
        getStartedButton.layer.cornerRadius = 20
        
        //disclaimerLabel.text = "By continuing you accept our Terms of Service"
        
    }

    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.getStartedTapped()
        
    }
    @IBAction func restorePurchaseTapped(_ sender: Any) {
        delegate?.restorePurchaseTapped()
    }
    
    @IBAction func TermsTapped(_ sender: Any) {
        delegate?.termsTapped()
    }

}
