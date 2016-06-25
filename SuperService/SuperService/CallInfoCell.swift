//
//  CallInfoCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
typealias ServiceStatusChangeSuccessClourse = (titleString:String) ->Void
enum StatusType:Int {
  case Unknown = 0
  case Unassigned //未指派
  case AlreadyAssigned //已指派
  case BeReady //就绪
  case Complete //完成
}
class CallInfoCell: UITableViewCell {
  var serviceStatusChangeSuccessClourse:ServiceStatusChangeSuccessClourse?
  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var beReadyStatus: UILabel!
  @IBOutlet weak var assignBtn: UIButton!
  @IBOutlet weak var beReadyBtn: UIButton!
  @IBOutlet weak var endServerBtn: UIButton!
  @IBOutlet weak var serverStatus: NSLayoutConstraint!
  @IBOutlet weak var callServertime: UILabel!
  @IBOutlet weak var clientnameAndLocation: UILabel!
  @IBOutlet weak var clientImageView: UIButton!
  @IBOutlet weak var topLineImageView: UIImageView!
  @IBOutlet weak var serviceName: UILabel!
  var taskID = ""
  var operationseq = ""
  var taskaction = 0
  var userid = ""
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  class func reuseIdentifier() -> String {
    return "CallInfoCell"
  }
  
  class func nibName() -> String {
    return "CallInfoCell"
  }
  
  class func height() -> CGFloat {
    return DeviceType.IS_IPAD ? 210 : 150
  }
  
  func confing(service:CallServiceModel) {
    clientImageView.sd_setImageWithURL(NSURL(string: (service.userimage?.fullImageUrl)!), forState: .Normal)
//    clientnameAndLocation.text = service.operationseq
    if let name = service.username,let svr = service.svrname {
      serviceName.text = name + "\(svr)"
    }
    callServertime.text = service.createtime
    beReadyStatus.text = service.status
    switch service.statuscode {
    case StatusType.Unassigned:
      beReadyStatus.textColor = UIColor.hx_colorWithHexRGBAString("#e51c23")
      statusImageView.backgroundColor = UIColor.hx_colorWithHexRGBAString("#e51c23")
    case StatusType.BeReady:
      beReadyStatus.textColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
      statusImageView.backgroundColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
    case StatusType.Complete:
      beReadyStatus.textColor = UIColor.hx_colorWithHexRGBAString("#888888")
      statusImageView.backgroundColor = UIColor.hx_colorWithHexRGBAString("#888888")
    case StatusType.AlreadyAssigned:
      beReadyStatus.textColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
      statusImageView.backgroundColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
    default:
      return
    }
    if let taskid = service.taskid,let operationseq = service.operationseq,let target = service.userid {
      taskID = taskid
      self.operationseq = String(operationseq)
      userid = target
    }
    
    endServerBtn.addTarget(self, action: #selector(CallInfoCell.taskAction), forControlEvents: .TouchUpInside)
    endServerBtn.tag = 1
    
    beReadyBtn.addTarget(self, action: #selector(CallInfoCell.taskAction), forControlEvents: .TouchUpInside)
    beReadyBtn.tag = 2
    
  }
  
  func taskAction(sender:UIButton) {
    switch sender.tag {
    case 1:
      changeStatus(5,isNeeded: false)
    case 2:
      changeStatus(3,isNeeded: false)
    default:
      return
    }
  }
  
  func changeStatus(taskaction:Int,isNeeded:Bool) {
    HttpService.sharedInstance.servicetaskStatusChange(taskID, operationseq: operationseq, taskaction: taskaction, target: userid,targetIsNeeded:isNeeded) { (json, error) in
      if let _ = error {

      } else {
        if let data = json {
          if data == "success" {
            if let closure = self.serviceStatusChangeSuccessClourse {
              if taskaction == 5 {
                closure(titleString: "已完成")
              }
              if taskaction == 3 {
              closure(titleString: "已就绪")
            }
          }

        }
      }
    }
  }
    }
}
