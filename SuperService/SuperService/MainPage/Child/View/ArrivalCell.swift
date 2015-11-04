//
//  ArrivalCell.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIButton! {
    didSet {
      avatarImageView.layer.masksToBounds = true
      avatarImageView.layer.cornerRadius = 20
    }
  }
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
  
  func setData(data: ClientArrivalInfo) {
    var userLevel = ""
    var userName = ""
    var userLocation = ""
    
    // 客户信息
    if let client = data.client {
      if let level = client.level {
        userLevel = "VIP\((level.integerValue + 1))"
      } else {
        userLevel = "新客户"
      }
      
      if let name = client.name {
        userName = name
      }
      
      if let phone = client.phone {
        self.phone = phone
      }
      
      if let userID = client.id {
        var url = NSURL(string: kBaseURL)
        url = url?.URLByAppendingPathComponent("uploads/users/\(userID).jpg")
        avatarImageView.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "img_hotel_zhanwei"))
      }
    }
    clientInfoLabel.text = userLevel + " " + userName
    
    
    // 客户位置信息
    if let location = data.location {
      userLocation = location.name!
    }
    locationLabel.text = "到达\(userLocation)"
    
    // 订单信息
    if let order = data.order {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let arrivalDate = dateFormatter.dateFromString(order.arrivalDate!)
      dateFormatter.dateFormat = "M/dd"
      let arrivalDateString = dateFormatter.stringFromDate(arrivalDate!)
      let orderInfo = "\(order.roomType!) | \(order.duration!)晚 | \(arrivalDateString)入住"
      orderButton.setTitle(orderInfo, forState: .Normal)
    } else {
      orderButton.setTitle("无订单", forState: .Normal)
    }
    
    // 多久以前
    if let timeAgoDate = data.timestamp {
      timeAgoLabel.text = timeAgoDate.timeAgoSinceNow()
    }
    
    // 提示信息
    infoLabel.text = "请准备好为其服务"
    
    // 随机颜色的小图标
    statusImageView.backgroundColor = UIColor(randomFlatColorOfShadeStyle: .Light)
  }
  
}