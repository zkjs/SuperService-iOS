//
//  SettingsHeaderView.swift
//  SuperService
//
//  Created by admin on 15/10/23.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingsHeaderView: UIView {
  
  @IBOutlet weak var userAddress: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var userImage: UIImageView! {
    didSet {
      userImage.layer.masksToBounds = true
      userImage.layer.cornerRadius = userImage.frame.width / 2.0
    }
  }
  
  /*
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
}
