//
//  SelectServiceAreaCell.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class SelectServiceAreaCell: UITableViewCell {

  @IBOutlet weak var areaLabel: UILabel!
  @IBOutlet weak var selectedButton: UIButton!
  var isUncheck = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setData(area: AreaModel) {
    areaLabel.text = area.area
  }

  @IBAction func tappedCheckedButton(sender: AnyObject) {
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
