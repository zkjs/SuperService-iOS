//
//  MessageCell.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

  class func reuseIdentifier() -> String {
    return "MessageCell"
  }
  
  class func nibName() -> String {
    return "MessageCell"
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
