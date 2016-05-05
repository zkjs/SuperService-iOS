//
//  teamListCell.swift
//  SuperService
//
//  Created by admin on 15/10/20.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class TeamListCell: UITableViewCell /*SWTableViewCell*/ {
  
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var userImage: UIImageView!{
    didSet {
      userImage.layer.masksToBounds = true
      userImage.layer.cornerRadius = userImage.frame.width / 2.0
    }
  }

  var salesid:String!
  var avatarTappedClosure: (()->Void)?
  
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
    return 100
  }
  
  func setData(team:TeamModel,avatarTapped:(()->Void)?) {
    
    username.text = team.username
    if let url = NSURL(string:team.avatarURL) {
      userImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_logo"))
    }
    avatarTappedClosure = avatarTapped
    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("avatarTapped:"))
    userImage.addGestureRecognizer(tapGestureRecognizer)
    userImage.userInteractionEnabled = true
  }
  
  func rightButtons() -> NSArray {
    let rightUtilityButtons: NSMutableArray = []
    rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除")
    return rightUtilityButtons
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func avatarTapped(sender: UIGestureRecognizer) {
    if let tap = avatarTappedClosure {
      tap()
    }
  }
  
}
