//
//  NewsItemTableViewCell.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/9/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class NewsItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var excerptLabel: UILabel!
    var newsItem : NewsItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCell() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let newsItem = newsItem {
            excerptLabel.text = newsItem.excerpt
            if let pictureName = newsItem.pictureURL {
                let reference = storageRef.child("\(pictureName).png")
                let placeholder = UIImage(named: "SGLOGO")
                backgroundImage.sd_setImage(with: reference, placeholderImage: placeholder)
            }
        }
    }
    
}
