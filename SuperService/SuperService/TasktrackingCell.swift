//
//  TasktrackingCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TasktrackingCell: UITableViewCell {

  @IBOutlet weak var actionImageView: UIImageView!
  @IBOutlet weak var assigntimeLabel: UILabel!
  @IBOutlet weak var assigntoLabel: UILabel!
  @IBOutlet weak var assignerImageView: UIImageView!
  @IBOutlet weak var bottomLabel: UILabel!
  @IBOutlet weak var topLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
  
  func configCell(taskhistory:TaskhistoryModel) {
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss" 
    if let dateString = taskhistory.createtime {
      let dateFormat = NSDateFormatter()
      dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss" 
      if let date = dateFormat.dateFromString(dateString) {
        dateFormat.dateFormat = "HH:mm"
        assigntimeLabel.text = dateFormat.stringFromDate(date)
      }
    }
    if let desc = taskhistory.actiondesc {
      assigntoLabel.text = desc 
    }
    
    assignerImageView.sd_setImageWithURL(NSURL(string: (taskhistory.userimage?.fullImageUrl)!)!, placeholderImage: UIImage(named: "mainIcon"))
    switch taskhistory.statuscode {
    case ActionType.Rated:
      actionImageView.image = UIImage(named: "ic_pingjia")
    case ActionType.Complete:
      actionImageView.image = UIImage(named: "ic_gou_r")
    case ActionType.Assign:
      actionImageView.image = UIImage(named: "ic_shang_r")
    case ActionType.BeReady:
      actionImageView.image = UIImage(named: "ic_shang_r")
    case ActionType.Cancle:
      actionImageView.image = UIImage(named: "ic_shang_r")
    case ActionType.LauncMission:
      actionImageView.image = UIImage(named: "ic_-round_blue")
    default:
      return
      
    }

    
  }
  
  
    
}
