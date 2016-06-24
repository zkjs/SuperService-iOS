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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func congfigCell(department:RolesWithShopModel) {
      departmentLabel.text = department.rolename
    }

}
