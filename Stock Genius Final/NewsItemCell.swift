//
//  NewsItemCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 8/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class NewsItemCell: UITableViewCell {

    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func formatCellWithNewsItem(_ newsItem: NewsItem) {
        
        headlineLabel.text = newsItem.headline
        sourceLabel.text = newsItem.source
        summaryLabel.text = newsItem.summary
        timeStampLabel.text = newsItem.createdAtString()
        
    }
    
}
