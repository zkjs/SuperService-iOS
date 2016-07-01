//
//  InvitationlistCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/30.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class InvitationlistCell: UITableViewCell {

  @IBOutlet weak var statusButton: UIButton!
  @IBOutlet weak var personCount: UILabel! {
    didSet {
      personCount.text = ""
    }
  }
  @IBOutlet weak var username: UILabel! {
    didSet {
      username.text = ""
    }
  }
  override func awakeFromNib() {
      super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  func configCell(personInfo:InvitepersonModel) {
    username.text = personInfo.username
    if let takeperson = personInfo.takeperson {
      personCount.text = String(takeperson) +  "人"
    }
    if personInfo.confirmstatusCode == 0 {
      statusButton.setTitle("未确认", forState: .Normal)
      statusButton.tintColor = UIColor.hx_colorWithHexRGBAString("#e51c23")
    }
    if personInfo.confirmstatusCode == 1 {
      statusButton.setTitle("已确认", forState: .Normal)
      statusButton.tintColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
    }
    if personInfo.confirmstatusCode == 2 {
      statusButton.setTitle("已取消", forState: .Normal)
      statusButton.tintColor = UIColor.hx_colorWithHexRGBAString("#888888")
    }
    
  }

}
