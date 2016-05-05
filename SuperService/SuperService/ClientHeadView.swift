//
//  ClientHeadView.swift
//  SuperService
//
//  Created by AlexBang on 16/4/28.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ClientHeadView: UICollectionReusableView {
        
  @IBOutlet weak var clientImage: UIImageView!
  @IBOutlet weak var tagLabel: UILabel!
  
  func setupView(clientInfo:ArrivateModel) {
    if let url = NSURL(string:clientInfo.avatarURL) {
      if DeviceType.IS_IPAD {
        clientImage.cornerRadius = 100
      }
      self.clientImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_logo"))
      
      if let username = clientInfo.username {
        tagLabel.text = username + " " + clientInfo.displayGender
      } 
    }
  }
}
