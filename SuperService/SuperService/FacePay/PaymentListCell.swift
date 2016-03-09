//
//  PaymentListItem.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class PaymentListCell: UITableViewCell {

  @IBOutlet weak var avatarsImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  func configCell(item:PaymentListItem) {
    usernameLabel.text = item.username
    timeLabel.text = item.createtime
    amountLabel.text = "￥\(item.amount)"
    statusLabel.text = item.statusdesc
  }
  
}
