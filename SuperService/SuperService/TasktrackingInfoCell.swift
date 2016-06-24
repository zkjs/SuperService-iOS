//
//  TasktrackingInfoCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TasktrackingInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  class func reuseIdentifier() -> String {
    return "TasktrackingInfoCell"
  }
  
  class func nibName() -> String {
    return "TasktrackingInfoCell"
  }
  
  class func height() -> CGFloat {
    return DeviceType.IS_IPAD ? 160 : 100
  }
    
}
