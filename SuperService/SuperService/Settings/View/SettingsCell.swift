//
//  SettingsCell.swift
//  SuperService
//
//  Created by admin on 15/10/23.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  class func reuseIdentifier() -> String {
    return "SettingsCell"
  }
  
  class func nibName() -> String {
    return "SettingsCell"
  }
  
  class func height() -> CGFloat {
    return 60
  }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
