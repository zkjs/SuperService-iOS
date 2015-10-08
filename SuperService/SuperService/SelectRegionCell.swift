//
//  SelectRegionCell.swift
//  SuperService
//
//  Created by Hanton on 9/30/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class SelectRegionCell: UITableViewCell {

  class func reuseIdentifier() -> String {
    return "SelectRegionCell"
  }
  
  class func nibName() -> String {
    return "SelectRegionCell"
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
