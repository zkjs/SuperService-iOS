//
//  TasktrackingCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TasktrackingCell: UITableViewCell {

  @IBOutlet weak var assigntimeLabel: UILabel!
  @IBOutlet weak var assigntoLabel: UILabel!
  @IBOutlet weak var assignerImageView: UIImageView!
  @IBOutlet weak var bottomLabel: UILabel!
  @IBOutlet weak var topLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  class func reuseIdentifier() -> String {
    return "TasktrackingCell"
  }
  
  class func nibName() -> String {
    return "TasktrackingCell"
  }
  
  class func height() -> CGFloat {
    return DeviceType.IS_IPAD ? 160 : 100
  }
    
}
