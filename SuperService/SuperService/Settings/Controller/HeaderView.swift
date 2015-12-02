//
//  HeaderView.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class HeaderView: UIView {

  @IBOutlet weak var selectedImageViewButton: UIButton!
  @IBOutlet weak var userImageView: UIImageView!{
    didSet {
      userImageView.layer.masksToBounds = true
      userImageView.layer.cornerRadius = userImageView.frame.width / 2.0
    }
  }

  @IBOutlet weak var usernameLabel: UILabel!
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
}
