//
//  RolesWithShopCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class RolesWithShopCell: UITableViewCell {

  @IBOutlet weak var selectedImageView: UIImageView!
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


  
  func changeSelectedButtonImage() {
    isUncheck = !isUncheck
    if isUncheck {
      // check
      selectedImageView.image = UIImage(named: "ic_jia_nor")
     
    } else {
      // uncheck
      selectedImageView.image = UIImage(named: "ic_jia_pre")
    }
  }
}
