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
        self.tagLabel.text = username + "  "  + "\(sex)"
      }
    }
  }
}
