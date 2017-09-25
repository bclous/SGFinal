//
//  STMessageCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/25/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit
import Alamofire

protocol STMessageCellDelegate : class {
    func pictureTapped(message: STMessage)
}

class STMessageCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var messageImageImageView: UIImageView!
    @IBOutlet weak var messageImageViewHeightConstraint: NSLayoutConstraint!
    var message : STMessage?
    weak var delegate : STMessageCellDelegate?
    
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
    
    func formatCellWithMessage(_ message: STMessage, cellWidth: CGFloat) {
        
        self.message = message
        userNameLabel.text = message.user.userName
        messageBodyLabel.attributedText = message.finalMessageString()
        timeStampLabel.text = message.dateCreated.timeStamp()
        formatAvatarImageFromMessage(message)
        formatMessageImageFromMessage(message)
        formatImageHeightFromMessage(message, cellWidth: cellWidth)

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
    
    private func formatMessageImageFromMessage(_ message: STMessage) {
        
        messageImageImageView.isUserInteractionEnabled = false
        
        let primaryImageAddress = message.primaryImageAddress()
        if let address = primaryImageAddress {
            let image = message.messageImage(isLowRes: true)
            if let image = image {
                messageImageImageView.image = image
                messageImageImageView.isUserInteractionEnabled = true
            } else {
                Alamofire.request(address).responseData(completionHandler: { (response) in
                    if let data = response.result.value {
                        self.messageImageImageView.image = UIImage(data: data)
                        if let _ = message.image {
                            message.cacheMessageImage(UIImage(data: data)!, isLowRes: true)
                        } else {
                            message.cacheMessageImage(UIImage(data: data)!, isLowRes: true)
                            message.cacheMessageImage(UIImage(data: data)!, isLowRes: false)
                        }
                        
                        self.messageImageImageView.isUserInteractionEnabled = true
                    }
                })
            }
        }
        
    }
    
    private func formatImageHeightFromMessage(_ message: STMessage, cellWidth: CGFloat) {
        
        let imageWidth = cellWidth - 75.0
        let imageHeight = 0.56 * imageWidth
        
        if let _ = message.primaryImageAddress() {
            messageImageViewHeightConstraint.constant = imageHeight
            messageImageImageView.layer.cornerRadius = 5
            messageImageImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            messageImageImageView.layer.borderWidth = 1
            
        } else {
            messageImageViewHeightConstraint.constant = 0
            messageImageImageView.layer.cornerRadius = 5
            messageImageImageView.layer.borderWidth = 0
        }
        
        contentView.layoutIfNeeded()
    }
    
    @IBAction func pictureTapped(_ sender: Any) {
        delegate?.pictureTapped(message: message!)
    }

}
