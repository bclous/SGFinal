//
//  TabBar.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 6/27/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum TabBarChoice {
    case pastPicks
    case currentPicks
    case calculator
}

protocol TabBarDelegate : class {
    func indexChosen(_ index:TabBarChoice)
}

class TabBar: UIView {

    @IBOutlet weak var index2ImageView: UIImageView!
    @IBOutlet weak var index2Label: UILabel!
    @IBOutlet weak var index1ImageView: UIImageView!
    @IBOutlet weak var index1Label: UILabel!
    @IBOutlet weak var index0ImageView: UIImageView!
    @IBOutlet weak var index0Label: UILabel!
    @IBOutlet var contentView: UIView!
    weak var delegate : TabBarDelegate?
    var currentChoice : TabBarChoice = .currentPicks
    var activeImageAlpha : CGFloat = 1.0
    var inactiveImageAlpha : CGFloat = 0.25
    var activeLabelAlpha : CGFloat = 1.0
    var inactiveLabelAlpha : CGFloat = 0.25
    
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TabBar", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        adjustTabBarForChoice(.currentPicks)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            currentChoice = .pastPicks
        case 1:
            currentChoice = .currentPicks
        case 2:
            currentChoice = .calculator
        default:
            currentChoice = .currentPicks
        }
        adjustTabBarForChoice(currentChoice)
        delegate?.indexChosen(currentChoice)
    }
    
    func adjustTabBarForChoice(_ index: TabBarChoice) {
        
        index0ImageView.alpha = index == .pastPicks ? activeImageAlpha : inactiveImageAlpha
        index1ImageView.alpha = index == .currentPicks ? activeImageAlpha : inactiveImageAlpha
        index2ImageView.alpha = index == .calculator ? activeImageAlpha : inactiveImageAlpha
        index0Label.alpha = index == .pastPicks ? activeLabelAlpha : inactiveLabelAlpha
        index1Label.alpha = index == .currentPicks ? activeLabelAlpha : inactiveLabelAlpha
        index2Label.alpha = index == .calculator ? activeLabelAlpha : inactiveLabelAlpha
       
    }

}
