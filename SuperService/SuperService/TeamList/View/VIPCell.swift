//
//  VIPCell.swift
//  SuperService
//
//  Created by AlexBang on 16/5/23.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class VIPCell: UITableViewCell {

  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var VIPMarkLabel: UILabel!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var VIPStatusLabel: UILabel!
  @IBOutlet weak var VIPVisitLabel: UILabel!
  @IBOutlet weak var VIPPhoneLabel: UILabel!
  @IBOutlet weak var VIPNameLabel: UILabel!
  @IBOutlet weak var VIPImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  class func reuseIdentifier() -> String {
    return "VIPCell"
  }
  
  class func nibName() -> String {
    return "VIPCell"
  }
  
  class func height() -> CGFloat {
    return 160
  }
  
  func configCell(VIP:AddClientModel) {
    if VIP.lastvisit?.isEmpty == true {
      VIPVisitLabel.text = "上次来访:  无记录"
    } else {
      VIPVisitLabel.text = "上次来访:  \(VIP.lastvisit!)"
    }
    switch VIP.loginstatus {
    case .UnLogin :
      VIPStatusLabel.text = "未登录"
      VIPStatusLabel.textColor = UIColor.redColor()
    case .IsLogin:
      VIPStatusLabel.text = "已登录"
      VIPStatusLabel.textColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
    default:
      break
   }
    VIPMarkLabel.text = VIP.rmk
    VIPNameLabel.text = VIP.username
    VIPPhoneLabel.text = VIP.phone
    VIPImageView.sd_setImageWithURL(NSURL(string: (VIP.userimage?.fullImageUrl)!), placeholderImage: nil)
  }
    
}
