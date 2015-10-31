//
//  MessageCell.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var lastChatLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var unreadLabel: UILabel!
  
  
  class func reuseIdentifier() -> String {
    return "MessageCell"
  }
  
  class func nibName() -> String {
    return "MessageCell"
  }
  
  class func height() -> CGFloat {
    return 70
  }
  
  func setData(conversation: Conversation) {
    if let userID = conversation.fromID {
      var url = NSURL(string: kBaseURL)
      url = url?.URLByAppendingPathComponent("uploads/users/\(userID).jpg")
      photoImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "img_hotel_zhanwei"))
    }
    titleLabel.text = conversation.title
    lastChatLabel.text = conversation.lastChat
    timestampLabel.text = conversation.timestamp?.timeAgoSinceNow()
    unreadLabel.text = conversation.unread?.stringValue
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
    
}
