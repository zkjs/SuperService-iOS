//
//  TaskExecutionDepartmentCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskExecutionDepartmentCell: UITableViewCell {

  @IBOutlet weak var departmentButton: UIButton!
  @IBOutlet weak var departmentLabel: UILabel!
  var isUncheck = true
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func congfigCell(department:RolesWithShopModel) {
      departmentLabel.text = department.rolename
    }

  @IBAction func tappedCheckedButton(sender: AnyObject) {
    changeSelectedButtonImage()
  }
  
  func changeSelectedButtonImage() {
    isUncheck = !isUncheck
    if isUncheck {
      // check
      departmentButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
      
    } else {
      // uncheck
      departmentButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    }
  }
}
