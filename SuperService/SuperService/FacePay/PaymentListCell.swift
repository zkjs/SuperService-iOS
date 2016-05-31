//
//  PaymentListItem.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class PaymentListCell: UITableViewCell {

  @IBOutlet weak var avatarsImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var customImage: UIImageView!

  func configCell(item:PaymentListItem) {
    usernameLabel.text = item.custom.username
    print(item.custom.username)
    avatarsImageView.sd_setImageWithURL(NSURL(string: item.custom.userimage.fullImageUrl), placeholderImage: UIImage(named: "avatars_default_white"))
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormat.dateFromString(item.createtime) {
      dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
      timeLabel.text = dateFormat.stringFromDate(date)
    }
    amountLabel.text = "￥\(item.displayAmount)"
    statusLabel.text = item.statusdesc
    if item.status == 2 {//已确认支付
      statusLabel.textColor = UIColor.hx_colorWithHexRGBAString("#03A9F4")
      customImage.backgroundColor = UIColor.hx_colorWithHexRGBAString("#03A9F4")
    }
    if item.status == 1 {//等待支付
      statusLabel.textColor = UIColor.hx_colorWithHexRGBAString("#F06951")
      customImage.backgroundColor = UIColor.hx_colorWithHexRGBAString("#F06951")
    }
    if item.status == 0 {//拒绝支付
      statusLabel.textColor = UIColor.hx_colorWithHexRGBAString("#FFC56E")
      customImage.backgroundColor = UIColor.hx_colorWithHexRGBAString("#FFC56E")
    }


    
  }
  
}
