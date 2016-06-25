//
//  TaskAssignCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/25.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskAssignCell: UITableViewCell {

  @IBOutlet weak var userlocation: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func congfigCell(department:TeamModel) {
    username.text = department.username
    userlocation.text = department.roledesc

    if let url = NSURL(string:department.avatarURL) {
      userImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_logo"))
    }
  }

}
