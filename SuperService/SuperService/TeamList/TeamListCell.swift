//
//  teamListCell.swift
//  SuperService
//
//  Created by admin on 15/10/20.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class TeamListCell: UITableViewCell {
  
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  class func reuseIdentifier() -> String {
    return "TeamListCell"
  }
  
  class func nibName() -> String {
    return "TeamListCell"
  }
  
  class func height() -> CGFloat {
    return 140
  }
  
  func setData(team:TeamModel) {
    username.text = team.name
    print(team.name)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
