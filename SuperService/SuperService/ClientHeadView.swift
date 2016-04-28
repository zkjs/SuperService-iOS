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
    let urlString = NSURL(string: kImageURL)
    if let userImage = clientInfo.userimage {
      let url = urlString?.URLByAppendingPathComponent("\(userImage)")
      self.clientImage.sd_setImageWithURL(url, placeholderImage: nil)
      
      if let sex = clientInfo.sex,let username = clientInfo.username {
        switch sex {
        case 1: 
          return self.tagLabel.text = username + "  "  + "男"
        case 0:
          return self.tagLabel.text = username + "  "  + "女"
        default:
          self.tagLabel.text = username
          break
        }
        
      } 
    }
  }
}
