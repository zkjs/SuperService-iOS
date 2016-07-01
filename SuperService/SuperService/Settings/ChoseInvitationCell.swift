//
//  ChoseInvitationCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/30.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ChoseInvitationCell: UITableViewCell {

  @IBOutlet weak var choiceButton: UIButton!
  @IBOutlet weak var groupingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configCell(person:InvitationpersonModel) {
    groupingLabel.text = person.rolename
  }

}
