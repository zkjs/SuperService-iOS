//
//  CallInfoCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class CallInfoCell: UITableViewCell {

  @IBOutlet weak var beReadyStatus: UILabel!
  @IBOutlet weak var assignBtn: UIButton!
  @IBOutlet weak var beReadyBtn: UIButton!
  @IBOutlet weak var endServerBtn: UIButton!
  @IBOutlet weak var serverStatus: NSLayoutConstraint!
  @IBOutlet weak var callServertime: UILabel!
  @IBOutlet weak var clientnameAndLocation: UILabel!
  @IBOutlet weak var clientImageView: UIButton!
  @IBOutlet weak var topLineImageView: UIImageView!
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  class func reuseIdentifier() -> String {
    return "CallInfoCell"
  }
  
  class func nibName() -> String {
    return "CallInfoCell"
  }
  
  class func height() -> CGFloat {
    return DeviceType.IS_IPAD ? 210 : 150
  }
    
}
