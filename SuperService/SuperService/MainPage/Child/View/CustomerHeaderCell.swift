//
//  CustomerHeaderCell.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class CustomerHeaderCell: UICollectionViewCell {
  static let PADDING = 20 // cell padding
  
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var userNameLabel: UILabel!
  
  override func awakeFromNib() {
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).CGColor
    avatarImageView.layer.borderWidth = 2
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    avatarImageView.layer.cornerRadius = (CGRectGetWidth(layoutAttributes.bounds) - CGFloat(CustomerHeaderCell.PADDING * 2)) / 2
  }
  
  func configCell(user:NearbyCustomer) {
    userNameLabel.text = user.username
    avatarImageView.sd_setImageWithURL(NSURL(string: user.userimage), placeholderImage: UIImage(named: "avatars_default_white"))
  }
}
