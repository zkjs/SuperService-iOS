//
//  PersonunderMemberCell.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class PersonunderMemberCell: UITableViewCell {

  @IBOutlet weak var checkImageView: UIImageView!
  @IBOutlet weak var personnameLabel: UILabel!
  @IBOutlet weak var personImageView: UIImageView!
  @IBOutlet weak var personChoiceButton: UIButton!
  var  isUncheck = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configCell(person:MemberpersonModel) {
    if let imageUrl:String = person.userimage,let name:String = person.username {
      personImageView.sd_setImageWithURL(NSURL(string: imageUrl.fullImageUrl))
      personnameLabel.text = name
    }
  }
  
  func changeSelectedButtonImage() {
    isUncheck = !isUncheck
    if isUncheck {
      // check
      checkImageView.image = UIImage(named: "ic_-round_blue")
      
    } else {
      // uncheck
      checkImageView.image = UIImage(named: "ic_jia_pre")
    }
  }

}
