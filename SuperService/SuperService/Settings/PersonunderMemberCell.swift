//
//  PersonunderMemberCell.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class PersonunderMemberCell: UITableViewCell {

  @IBOutlet weak var personnameLabel: UILabel!
  @IBOutlet weak var personImageView: UIImageView!
  @IBOutlet weak var personChoiceButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configCell(person:MemberpersonModel) {
    if let imageUrl = person.userimage,let name = person.username {
      personImageView.sd_setImageWithURL(NSURL(string: imageUrl.fullImageUrl))
      personnameLabel.text = name
    }
    
  }

}
