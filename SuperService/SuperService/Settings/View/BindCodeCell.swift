//
//  BindCodeCell.swift
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class BindCodeCell: UITableViewCell {
  
  @IBOutlet weak var codeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  class func reuseIdentifier() -> String {
    return "BindCodeCell"
  }
  
  class func nibName() -> String {
    return "BindCodeCell"
  }
  
  class func height() -> CGFloat {
    return 60
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setData(code: BindCodeModel) {
    codeLabel.text = code.code
    nameLabel.text = code.username
    phoneLabel.text = code.phone
    if let userimage = code.userimage,let url = NSURL(string:userimage.avatarURL) {
      avatarImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_logo"))
    }
  }
  
}
