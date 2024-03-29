//
//  InformCell.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class InformCell: UITableViewCell {

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
    return "InformCell"
  }
  
  class func nibName() -> String {
    return "InformCell"
  }
  
  class func height() -> CGFloat {
    
    return DeviceType.IS_IPAD ? 150:80
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
      //changeSelectedButtonImage()
    }
  func setData(area: AreaModel) {
    locationLabel.text = area.area
  }
  
  func setContact(contact: [String:String]) {
    locationLabel.text = contact["username"]
    phoneLabel.text = contact["phone"]
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
