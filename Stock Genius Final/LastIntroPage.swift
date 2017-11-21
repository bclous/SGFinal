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
    case privacy
    case billing
}

protocol IntroScreenDelegate: class {
    func introScreenUserInteraction(_ choice: IntroScreenChoice)
}

class LastIntroPage: UIView {

   
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var restoreLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    weak var delegate : IntroScreenDelegate?
    @IBOutlet weak var mainImageView: UIImageView!
    var haveChangedConstraints = false
 
    
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

        
        let mutableAttributedString = NSMutableAttributedString()
    
        let privacy = NSAttributedString(string: "Privacy Policy", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        let terms = NSAttributedString(string: "Terms of Service", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        let billing = NSAttributedString(string: "Billing Terms", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        let firstBreak = NSAttributedString(string: ", ")
        let secondBreak = NSAttributedString(string: ", and ")
        let intro = NSAttributedString(string: "By continuing you accept our\n")
        
        mutableAttributedString.append(intro)
        mutableAttributedString.append(privacy)
        mutableAttributedString.append(firstBreak)
        mutableAttributedString.append(terms)
        mutableAttributedString.append(secondBreak)
        mutableAttributedString.append(billing)
        
        termsLabel.attributedText = mutableAttributedString
        
        
    }
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        delegate?.introScreenUserInteraction(.subscribe)
    }

    @IBAction func termsButtonTapped(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            delegate?.introScreenUserInteraction(.privacy)
        case 1:
            delegate?.introScreenUserInteraction(.terms)
        case 2:
            delegate?.introScreenUserInteraction(.billing)
        default:
            delegate?.introScreenUserInteraction(.billing)
        }
        
    }
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        delegate?.introScreenUserInteraction(.restore)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!haveChangedConstraints && frame.height == 812) {
            labelBottomConstraint.constant = labelBottomConstraint.constant + 45
            buttonBottomConstraint.constant = buttonBottomConstraint.constant + 45
            haveChangedConstraints = true
        }
        
        
    }


}
