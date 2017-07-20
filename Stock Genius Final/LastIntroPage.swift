//
//  LastIntroPage.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/12/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum IntroScreenChoice {
    case subscribe
    case restore
    case terms
}

protocol IntroScreenDelegate: class {
    func introScreenUserInteraction(_ choice: IntroScreenChoice)
}

class LastIntroPage: UIView {

    @IBOutlet weak var billingLabel: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    weak var delegate : IntroScreenDelegate?
    @IBOutlet weak var mainImageView: UIImageView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LastIntroPage", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        subscribeButton.layer.cornerRadius = 10
        subscribeButton.backgroundColor = SGConstants.mainBlueColor
        termsLabel.textColor = SGConstants.fontColorWhiteSecondary
        restoreLabel.textColor = SGConstants.fontColorWhiteSecondary
        billingLabel.textColor = SGConstants.fontColorWhiteSecondary
    }
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        delegate?.introScreenUserInteraction(.subscribe)
    }

    @IBAction func termsButtonTapped(_ sender: Any) {
        delegate?.introScreenUserInteraction(.terms)
    }
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        delegate?.introScreenUserInteraction(.restore)
    }

}
