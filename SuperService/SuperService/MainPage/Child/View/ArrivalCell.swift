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
  @IBOutlet weak var chatButton: UIButton!
  @IBOutlet weak var PhoneCall: UIButton!
  @IBOutlet weak var arrowButton: UIButton!
  
  var phone = ""
  var sex = ""
  
  
  class func reuseIdentifier() -> String {
    return "ArrivalCell"
  }
  
  class func nibName() -> String {
    return "ArrivalCell"
  }
  
  class func height() -> CGFloat {
    return 119
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
  
//  @IBAction func makePhoneCall(sender: AnyObject) {
//    let phoneURL = NSURL(string: "tel://\(phone)")
//    UIApplication.sharedApplication().openURL(phoneURL!)
//  }
  
  
  // MARK: - Private
  
  func setData(data: ArrivateModel) {
    
    guard let userName = data.username else {return}
    guard let sex = data.sex else {return}
    guard let Phone = data.phone else {return}
    phone = Phone
    var url = NSURL(string: kImageURL)
    if let userImage = data.userimage {
    url = url?.URLByAppendingPathComponent("\(userImage)")
    avatarImageView.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "default_logo"))
    clientInfoLabel.text = userName + "\(sex)"
    }
    // 客户位置信息
    if let location = data.locdesc {
     let userLocation = location
    locationLabel.text = "到达 \(userLocation)"
    }
   
    
    // 订单信息
    if let order = data.orders {
      print(order)
      if let firstOrder = order.first {
        orderButton.hidden = false
        arrowButton.hidden = false
        
        if let orderRoom = firstOrder["room"].string,
          let checkIn = firstOrder["indate"].string
        {
          let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormat.dateFromString(checkIn) {
              dateFormat.dateFormat = "HH:mm"
              let orderInfo = "\(orderRoom) | \(dateFormat.stringFromDate(date))"
              orderButton.setTitle(orderInfo, forState: .Normal)
          }
        }
      } else {
        orderButton.hidden = true
        arrowButton.hidden = true
      }
    } else {
      orderButton.hidden = true
      arrowButton.hidden = true
    }
  
    
    if let dateString = data.arrivetime {
      let dateFormat = NSDateFormatter()
      let nowDateFormate = NSDateFormatter()
      let nowDate = NSDate()
      dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss" 
      nowDateFormate.dateFormat = "yyyy-MM-dd 00:00:00" 
      if let date = dateFormat.dateFromString(dateString) {
        let nowString = nowDateFormate.stringFromDate(nowDate)
        let arrivateString = dateFormat.stringFromDate(date)
        if nowString > arrivateString {
          dateFormat.dateFormat = "MM-dd HH:mm"
        }else {
          dateFormat.dateFormat = "HH:mm"
        }
        
        timeAgoLabel.text = dateFormat.stringFromDate(date)
      }
    }
      
 
    

  }
  
  
}
