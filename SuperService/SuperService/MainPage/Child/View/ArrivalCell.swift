//
//  ArrivalCell.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIButton!
  @IBOutlet weak var topLineImageView: UIImageView!
  @IBOutlet weak var clientInfoLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet weak var orderButton: UIButton!
  @IBOutlet weak var statusImageView: UIImageView!
  
  var phone = ""
  
  
  class func reuseIdentifier() -> String {
    return "ArrivalCell"
  }
  
  class func nibName() -> String {
    return "ArrivalCell"
  }
  
  class func height() -> CGFloat {
    return 140
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  // MARK: - Button Action
  
  @IBAction func makePhoneCall(sender: AnyObject) {
    let phoneURL = NSURL(string: "tel://\(phone)")
    UIApplication.sharedApplication().openURL(phoneURL!)
  }
  
  
  // MARK: - Private
  
  func setData(data: [String: AnyObject]) {
    var userLevel = ""
    var userName = ""
    var userLocation = ""
    
    // 客户信息
    if let level = data["userApplevel"] as? NSNumber {
      userLevel = "VIP\((level.integerValue + 1))"
    } else {
      userLevel = "新客户"
    }
    
    if let name = data["userName"] as? String {
      userName = name
    }
    
    if let phone = data["phone"] as? String {
      self.phone = phone
    }
    
    if let userID = data["userId"] as? String {
      var url = NSURL(string: kImageURL)
      url = url?.URLByAppendingPathComponent("/uploads/users/\(userID).jpg")
      avatarImageView.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "img_hotel_zhanwei"))
    }
    clientInfoLabel.text = userName
    
    
    // 客户位置信息
    if let location = data["locname"] as? String {
      userLocation = location
    }
    locationLabel.text = "到达 \(userLocation)"
    
    // 订单信息
    if let order = data["orderForNotice"] as? [[String: AnyObject]] {
      print(order)
      if let firstOrder = order.first {
        if let orderRoom = firstOrder["orderRoom"] as? String,
          let checkIn = firstOrder["checkIn"] as? String,
          let checkInDate = firstOrder["checkInDate"] as? String {
            let orderInfo = "\(orderRoom) | \(checkIn) | \(checkInDate)"
            orderButton.setTitle(orderInfo, forState: .Normal)
        }
      } else {
        orderButton.setTitle("无订单", forState: .Normal)
      }
    } else {
      orderButton.setTitle("无订单", forState: .Normal)
    }
    
    // 多久以前
    if let dateString = data["created"] as? String {
      let dateFormat = NSDateFormatter()
      dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
      if let date = dateFormat.dateFromString(dateString) {
        timeAgoLabel.text = date.timeAgoSinceNow()
      }
    }
    
    // 提示信息
    infoLabel.text = "请准备好为其服务"
    
    // 随机颜色的小图标
    statusImageView.backgroundColor = UIColor(randomFlatColorOfShadeStyle: .Light)
  }
  
}
