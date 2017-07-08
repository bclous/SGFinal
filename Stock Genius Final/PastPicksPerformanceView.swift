//
//  PastPicksPerformanceView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class PastPicksPerformanceView: UIView {

    @IBOutlet weak var graphContainerView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sgGraphView: UIView!
    @IBOutlet weak var sgPerformanceLabel: UILabel!
   
  
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PastPicksPerformanceView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        
        
        
    }
    
    func formatPerformanceHeaderView(performance: [Float], frameWidth: CGFloat) {
        let percentage = CGFloat(performance[1] / performance[0])
    
        let indexView = UIView()
        indexView.backgroundColor = SGConstants.fontColorWhiteSecondary
        graphContainerView.addSubview(indexView)
        indexView.translatesAutoresizingMaskIntoConstraints = false
        indexView.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor).isActive = true
        indexView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        indexView.leftAnchor.constraint(equalTo: graphContainerView.leftAnchor).isActive = true
        indexView.widthAnchor.constraint(equalTo: graphContainerView.widthAnchor, multiplier: percentage).isActive = true
        
        let indexLabel = UILabel()
        indexView.addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.leftAnchor.constraint(equalTo: indexView.leftAnchor, constant: 10).isActive = true
        indexLabel.rightAnchor.constraint(equalTo: indexView.rightAnchor, constant: 5).isActive = true
        indexLabel.heightAnchor.constraint(equalTo: indexView.heightAnchor).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: indexView.centerYAnchor).isActive = true
        indexLabel.text = "S&P 500 INDEX"
        indexLabel.textColor = UIColor.white
        indexLabel.font = UIFont.systemFont(ofSize: 12)
        
        let indexPerformanceLabel = UILabel()
        self.addSubview(indexPerformanceLabel)
        indexPerformanceLabel.translatesAutoresizingMaskIntoConstraints = false
        indexPerformanceLabel.leftAnchor.constraint(equalTo: indexView.rightAnchor, constant: 5).isActive = true
        indexPerformanceLabel.centerYAnchor.constraint(equalTo: indexView.centerYAnchor, constant: 0).isActive = true
        indexPerformanceLabel.font = UIFont.systemFont(ofSize: 12)
        indexPerformanceLabel.textColor = UIColor.white
        
        indexView.layer.cornerRadius = 5
        
        sgGraphView.backgroundColor = SGConstants.mainBlueColor
        sgGraphView.layer.cornerRadius = 5
        
        indexPerformanceLabel.text = String(format: "+%.1f", performance[1]) + "%"
        sgPerformanceLabel.text = String(format: "+%.1f", performance[0]) + "%"
        
        
        
        
        
        
        
    }
}
