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
  
  func setData(order: OrderListModel) {
    // 客户信息
    clientInfoLabel.text = order.username
    
    // 客户头像
    if let userID = order.userid {
      var url = NSURL(string: kImageURL)
      url = url?.URLByAppendingPathComponent("/uploads/users/\(userID).jpg")
      avatarButton.sd_setImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "default_logo"))
    }
    
    // 订单状态 | 支付状态
    infoLabel.text = order.orderstatus
    
    // 订单信息
    let orderInfo = "\(order.roomtype!) | \(order.duration!)晚 | \(order.arrivalDateShortStyle!)入住"
    orderButton.setTitle(orderInfo, forState: .Normal)
    
    // 订单创建时间
    timeAgoLabel.text = order.createdDateString
    
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