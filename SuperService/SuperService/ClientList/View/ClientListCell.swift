//
//  ClientListCell.swift
//  SuperService
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class ClientListCell: UITableViewCell {

  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
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
    
  }
  
}
