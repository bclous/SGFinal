//
//  BrowserFooterView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/10/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum BrowserChoice {
    case back
    case forward
    case share
}

protocol BrowserFooterDelegate {
    func userTap(choice: BrowserChoice)
}

class BrowserFooterView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var forwardImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var delegate : BrowserFooterDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BrowserFooterView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        formatBrowserFooter(backAvailable: false, forwardAvailable: false)
    }
    
    public func formatBrowserFooter(backAvailable: Bool, forwardAvailable: Bool) {
        backImage.alpha = backAvailable ? 1 : 0.3
        backButton.isEnabled = backAvailable
        forwardImage.alpha = forwardAvailable ? 1 : 0.3
        forwardButton.isEnabled = forwardAvailable
    }

    @IBAction func backTapped(_ sender: Any) {
        delegate?.userTap(choice: .back)
        
    }
    @IBAction func shareTapped(_ sender: Any) {
        delegate?.userTap(choice: .share)
        
    }
    @IBAction func forwardTapped(_ sender: Any) {
        delegate?.userTap(choice: .forward)
    }

}
