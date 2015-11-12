//
//  OrderCell.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

  @IBOutlet weak var topLineImageView: UIImageView!
  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var clientInfoLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet weak var orderButton: UIButton!
  @IBOutlet weak var avatarButton: UIButton!
  
  class func reuseIdentifier() -> String {
    return "OrderCell"
  }
  
  class func nibName() -> String {
    return "OrderCell"
  }
  
  class func height() -> CGFloat {
    return 140
  }
  
  func setData(order: OrderModel) {
    // 客户信息
    clientInfoLabel.text = order.guest
    
    // 客户头像
    if let userID = order.userid {
      var url = NSURL(string: kBaseURL)
      url = url?.URLByAppendingPathComponent("uploads/users/\(userID).jpg")
      avatarButton.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "img_hotel_zhanwei"))
    }
    
    // 订单状态 | 支付状态
    infoLabel.text = "\(order.orderStatus!) | \(order.payStatus!)"
    
    // 订单信息
    let orderInfo = "\(order.room_type!) | \(order.duration!)晚 | \(order.arrivalDateShortStyle!)入住"
    orderButton.setTitle(orderInfo, forState: .Normal)
    
    // 订单创建时间
    timeAgoLabel.text = order.created
    
    // 随机颜色的小图标
    statusImageView.backgroundColor = UIColor(randomFlatColorOfShadeStyle: .Light)
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
