//
//  MassCell.swift
//  SuperService
//
//  Created by AlexBang on 16/3/9.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class MassCell: UITableViewCell {
  @IBOutlet weak var selectedButton: UIButton!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var ImageView: UIImageView!
  @IBOutlet weak var phoneLabel: UILabel!
  var isUncheck = true
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    //      selectedButton.selected  = true
  }
  class func reuseIdentifier() -> String {
    return "MassCell"
  }
  
  class func nibName() -> String {
    return "MassCell"
  }
  
  class func height() -> CGFloat {
    return 80
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    //changeSelectedButtonImage()
  }

  
  @IBAction func tappedCheckedButton(sender: UIButton) {
    changeSelectedButtonImage()
  }
  
  func changeSelectedButtonImage() {
    isUncheck = !isUncheck
    if isUncheck {
      // check
      selectedButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
      
    } else {
      // uncheck
      selectedButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    }
  }
  
}
