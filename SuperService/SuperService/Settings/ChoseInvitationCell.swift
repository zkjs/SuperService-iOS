//
//  ChoseInvitationCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/30.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ChoseInvitationCell: UITableViewCell {

  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var choiceButton: UIButton!
  @IBOutlet weak var groupingLabel: UILabel!
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
  var person : InvitationpersonModel? {
    didSet {
      groupingLabel.text = person?.rolename ?? ""
      if let count = person?.member.count {
        amountLabel.text = "(\(count)/\(count))"
      }
      changeSelectedButtonImage()
    }
  }
  var selectCallback:((index:Int)->Void)?

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  @IBAction func tappedCheckedButton(sender: AnyObject) {
    changeSelectedButtonImage()
    selectCallback?(index: sender.tag)
  }
  
  func configCell(person:InvitationpersonModel, callback:(index:Int)->Void) {
    groupingLabel.text = person.rolename
    if let count = person.member?.count {
      amountLabel.text = "(\(count)/\(count))"
    }
    self.person = person
    selectCallback = callback
  } 
  
  func changeSelectedButtonImage() {
    guard let person = person else { return }
    if !person.isAllSelected() {
      // check
      choiceButton.setImage(UIImage(named: "ic_-round_blue"), forState:UIControlState.Normal)
    } else {
      // uncheck
      choiceButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    }
  }

}
