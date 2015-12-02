//
//  ClientListCell.swift
//  SuperService
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class ClientListCell: UITableViewCell {
var salesid:String!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!{
    didSet {
      userImage.layer.masksToBounds = true
      userImage.layer.cornerRadius = userImage.frame.width / 2.0
    }
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  class func reuseIdentifier() -> String {
    return "ClientListCell"
  }
  class func nibName() -> String {
    return "ClientListCell"
  }
  class func height() -> CGFloat {
    return 100
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func setData(client: ClientModel) {
    userNameLabel.text = client.username
    if let salesid = client.salesid {
      self.salesid = salesid
    }
    
    let url = NSURL(string: kBaseURL)
    let urlStr = url?.URLByAppendingPathComponent("uploads/users/\(salesid).jpg")
    
    userImage.sd_setImageWithURL(urlStr, placeholderImage: UIImage(named: "img_hotel_zhanwei"))

  }
  
}
