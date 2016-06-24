//
//  CallInfoCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class CallInfoCell: UITableViewCell {

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
    clientnameAndLocation.text = service.operationseq
    serviceName.text = service.svrname
    callServertime.text = service.createtime
    beReadyStatus.text = service.status
    
  }
    
}
