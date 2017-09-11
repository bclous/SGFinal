//
//  GraphTableViewCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import SwiftChart

class GraphTableViewCell: UITableViewCell {

    @IBOutlet weak var graphContainerView: UIView!
    var data : [(x: Float, y: Float)] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutSubviews()
        
        if data.count > 0 {
            let chart = Chart(frame: CGRect(x: 0, y: 0, width: graphContainerView.frame.width, height: graphContainerView.frame.height))
            let series = ChartSeries(data: data)
            chart.add(series)
            graphContainerView.addSubview(chart)
            chart.backgroundColor = SGConstants.mainBlackColor
        }
    }
    
    
    func formatChartCell(stock: CurrentStock, timePeriod: IndividualSegmentType) {
        data = stock.graphDataFromType(timePeriod)

    }
    
}
