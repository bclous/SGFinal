//
//  STMessageCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Alamofire

class STMessageCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var messageImageImageView: UIImageView!
    @IBOutlet weak var messageImageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
        userNameLabel.textColor = SGConstants.fontColorWhitePrimary
        timeStampLabel.textColor = SGConstants.fontColorWhiteSecondary
        messageBodyLabel.textColor = SGConstants.fontColorWhiteSecondary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCellWithMessage(_ message: STMessage) {
        
        userNameLabel.text = message.user.userName
        messageBodyLabel.text = message.body
        timeStampLabel.text = message.dateCreated.timeStamp()
        formatAvatarImageFromMessage(message)
        messageImageImageView.image = UIImage(named:"emily")
        formatImageHeightFromMessage(message)
        
        
    }
    
    private func formatAvatarImageFromMessage(_ message: STMessage) {
        let avatarImage = message.user.avatarImage()
        if let avatarImage = avatarImage {
            avatarImageView.image = avatarImage
        } else {
            let imageURL = message.user.avatarSSLURL
            Alamofire.request(imageURL).responseData { response in
                if let data = response.result.value {
                    self.avatarImageView.image = UIImage(data: data)
                    message.user.cacheAvatarImage(UIImage(data: data)!)
                }
            }
        }
    }
    
    private func formatImageHeightFromMessage(_ message: STMessage) {
        
        if let imageURL = message.primaryImageAddress() {
            messageImageViewHeightConstraint.constant = 130
            
        } else {
            messageImageViewHeightConstraint.constant = 0
        }
        
        //contentView.layoutIfNeeded()
        
    }
    
    
    
}
