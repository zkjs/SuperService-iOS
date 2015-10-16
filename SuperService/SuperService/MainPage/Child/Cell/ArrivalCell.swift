//
//  ArrivalCell.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalCell: UITableViewCell {
  
  @IBOutlet weak var topLineImageView: UIImageView!
  @IBOutlet weak var clientInfoLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet weak var orderButton: UIButton!
  
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
  
}
