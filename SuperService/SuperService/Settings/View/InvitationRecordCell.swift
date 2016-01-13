//
//  InvitationRecordCell.swift
//  SuperService
//
//  Created by AlexBang on 15/11/7.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class InvitationRecordCell: UITableViewCell {

  @IBOutlet weak var useCodetimerLabel: UILabel!
  @IBOutlet weak var invitationerNameLabel: UILabel!
  @IBOutlet weak var invitationerImageView: UIImageView!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  class func reuseIdentifier() -> String {
    return "InvitationRecordCell"
  }
  
  class func nibName() -> String {
    return "InvitationRecordCell"
  }
  
  class func height() -> CGFloat {
    return 60
  }
  
  func setupData(user:CodeModel) {
//    invitationerNameLabel.text = user.username
//    useCodetimerLabel.text = user.created
//    let userID = user.userid
   
//    let url = NSURL(string: kImageURL)
//    let urlStr = url?.URLByAppendingPathComponent("uploads/users/\(userID!).jpg")
//     print(urlStr)
//    invitationerImageView.sd_setImageWithURL(urlStr, placeholderImage: UIImage(named: "img_hotel_zhanwei"))
  
  }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
