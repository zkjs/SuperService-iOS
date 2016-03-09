//
//  PaymentResultVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class PaymentResultVC: UIViewController {
  var payResult:FacePayResult!

  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var refusedLabel: UILabel!
  @IBOutlet weak var sendAgainButton: UIButton!
  
  override func viewDidLoad() {
    self.title = "收款结果"
    setupView()
  }
  
  private func setupView() {
    if payResult.success {
      amountLabel.text = "￥\(payResult.amount)"
      if payResult.waiting {
        statusLabel.text = "等待 \(payResult.customer.username) 确认"
        sendAgainButton.hidden = false
      } else {
        statusLabel.text = "\(payResult.customer.username) 收款成功"
        sendAgainButton.hidden = true
      }
    } else {
      
    }
  }
  
  @IBAction func sendAgain(sender: UIButton) {
  }
}
