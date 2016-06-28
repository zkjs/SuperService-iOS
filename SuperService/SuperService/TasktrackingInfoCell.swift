//
//  TasktrackingInfoCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TasktrackingInfoCell: UITableViewCell {

  @IBOutlet weak var serviceName: UILabel! {
    didSet {
      serviceName.text = ""
    }
  }
  @IBOutlet weak var userlocationAndassignTime: UILabel!
    {
    didSet {
      userlocationAndassignTime.text = ""
    }
  }

  @IBOutlet weak var userImageView: UIImageView!
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
  
  func configSectionHeader(task:TasktrackingModel) {
    if let urlString = task.userimage?.fullImageUrl {
      userImageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "mainIcon"))
    }
    if let name = task.username,let locdesc = task.locdesc,let time = task.createtime {
      let dateFormat = NSDateFormatter()
      dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss" 
      if let dateString:String = time {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss" 
        if let date = dateFormat.dateFromString(dateString) {
          dateFormat.dateFormat = "HH:mm"
          let timeStr = dateFormat.stringFromDate(date)
          userlocationAndassignTime.text = name + " (\(locdesc)) " + timeStr
        }
      }
    }
    serviceName.text = task.srvname
  }
    
}
