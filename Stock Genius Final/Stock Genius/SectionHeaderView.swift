//
//  SectionHeaderView.swift
//  Stock Genius
//
//  Created by Brian Clouser on 4/18/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate : class {
    func sectionHeaderButtonTapped(today: Bool)
}

class SectionHeaderView: UIView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var sinceDateView: UIView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var sinceDateLabel: UILabel!
    weak var delegate : SectionHeaderDelegate?
    var isTodayShown = true
    var showBorderView = false
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        todayView.layer.borderColor = SGConstants.mainBlueColor.cgColor
        todayView.layer.borderWidth = 2
        todayView.layer.cornerRadius = 5
        
        sinceDateView.layer.borderColor = SGConstants.mainBlueColor.cgColor
        sinceDateView.layer.borderWidth = 2
        sinceDateView.layer.cornerRadius = 5
        
        adjustButtonColors(today: isTodayShown)
        adjustBorderView()
    }
    
    func adjustBorderView() {
        borderView.isHidden = !showBorderView
    }

    @IBAction func todayButtonTapped(_ sender: Any) {
        adjustButtonColors(today: true)
        delegate?.sectionHeaderButtonTapped(today: true)
    }
    
    @IBAction func sinceButtonTapped(_ sender: Any) {
        adjustButtonColors(today: false)
        delegate?.sectionHeaderButtonTapped(today: false)
    }
    
    func adjustButtonColors(today: Bool) {
        todayView.backgroundColor = today ? SGConstants.mainBlueColor : UIColor.clear
        sinceDateView.backgroundColor = today ? UIColor.clear : SGConstants.mainBlueColor
    }
    
    func setSinceDate(date: String) {
        sinceDateLabel.text = "SINCE \(date)"
    }
    
}
