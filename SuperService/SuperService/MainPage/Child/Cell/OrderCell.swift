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
  @IBOutlet weak var clientInfoLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet weak var orderButton: UIButton!
  
  class func reuseIdentifier() -> String {
    return "OrderCell"
  }
  
  class func nibName() -> String {
    return "OrderCell"
  }
  
  class func height() -> CGFloat {
    return 140
  }
  
  func setData(order:OrderModel) {
    timeAgoLabel.text = order.created
    
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  @IBAction func calloutButton(sender: UIButton) {
  }
  @IBAction func sendMessageButton(sender: UIButton) {
  }
  @IBAction func shareButton(sender: UIButton) {
  }
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
    
}
