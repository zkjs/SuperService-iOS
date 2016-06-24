//
//  RolesWithShopCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class RolesWithShopCell: UITableViewCell {

  @IBOutlet weak var checkoutButton: UIButton!
  @IBOutlet weak var rolesPhoneLabel: UILabel!
  @IBOutlet weak var rolesnameLabel: UILabel!
  var isUncheck = true
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  func congfigCell(department:TeamModel) {
    rolesnameLabel.text = department.username
    rolesPhoneLabel.text = department.phone
    
  }

  @IBAction func tappedCheckedButton(sender: AnyObject) {
    changeSelectedButtonImage()
  }
  
  func changeSelectedButtonImage() {
    isUncheck = !isUncheck
    if isUncheck {
      // check
      checkoutButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
      
    } else {
      // uncheck
      checkoutButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    }
  }
}
