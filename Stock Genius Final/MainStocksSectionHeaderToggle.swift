//
//  MainStocksSectionHeaderToggle.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/1/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum CurrentPicksReturnType {
    case today
    case startDate
}

protocol CurrentPicksToggleDelegate: class {
    func toggleTapped(typeChosen: CurrentPicksReturnType)
}

class MainStocksSectionHeaderToggle: UIView {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    weak var delegate: CurrentPicksToggleDelegate?
    var isTodayChosen = false
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MainStocksSectionHeaderToggle", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentView.backgroundColor = SGConstants.mainBlackColor
        leftView.layer.cornerRadius = 5
        rightView.layer.cornerRadius = 5
        leftView.layer.borderColor = SGConstants.mainBlueColor.cgColor
        rightView.layer.borderColor = SGConstants.mainBlueColor.cgColor
        leftView.layer.borderWidth = 1
        rightView.layer.borderWidth = 1 
        leftLabel.text = "TODAY"
        rightLabel.text = "SINCE 3/14/2015"
        formatView(todayChosen: true)
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        formatView(todayChosen: sender.tag == 0)
        let type : CurrentPicksReturnType = sender.tag == 0 ? .today : .startDate
        delegate?.toggleTapped(typeChosen: type)
    }
    
    public func formatViewWithDateString(_ date: String) {
        rightLabel.text = "SINCE " + date
    }
    
    public func formatView(todayChosen: Bool) {
        
        if isTodayChosen != todayChosen {
            leftView.backgroundColor = todayChosen ? SGConstants.mainBlueColor : SGConstants.mainBlackColor
            rightView.backgroundColor = todayChosen ? SGConstants.mainBlackColor : SGConstants.mainBlueColor
            
            isTodayChosen = todayChosen
        }
        
    }
    
    

}
