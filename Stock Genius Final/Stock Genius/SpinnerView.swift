//
//  SpinnerView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var spinnerContainerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SpinnerView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        spinnerContainerView.layer.cornerRadius = 10
        spinner.startAnimating()
    }


}
