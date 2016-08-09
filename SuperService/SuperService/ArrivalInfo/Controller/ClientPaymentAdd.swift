//
//  ClientPaymentAdd.swift
//  SuperService
//
//  Created by Qin Yejun on 8/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

protocol ClientPaymentAddDelegate {
  func addSuccess()
}

class ClientPaymentAdd: UIViewController {
  var clientInfo: ArrivateModel!
  var delegate: ClientPaymentAddDelegate?
  
  @IBOutlet weak var amountField: LTBouncyTextField!
  @IBOutlet weak var remarkField: LTBouncyTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "增加消费记录"
  }
  
  @IBAction func submitAction(sender: UIButton) {
    if !checkAllFields() {
      return
    }
    showHudInView(view, hint: "")
    HttpService.sharedInstance.addPayment(clientInfo.userid!, amount: Double(amountField.text!.trim) ?? 0, remark: remarkField.text!.trim) { (succ, err) in
      self.hideHUD()
      if let err = err {
        self.showErrorHint(err)
      } else {
        self.delegate?.addSuccess()
        self.navigationController?.popViewControllerAnimated(true)
      }
    }
  }
  
  private func checkAllFields() -> Bool {
    guard let amount = amountField.text?.trim, remark = remarkField.text?.trim else {
      return false
    }
    if amount.isEmpty {
      showHint("金额不能为空")
      return false
    }
    if !amount.isDecimal {
      showHint("金额只能是数字")
      return false
    }
    if amount.length > 8 {
      showHint("金额过大")
      return false
    }
    if Double(amount) <= 0 {
      showHint("金额必须大于零")
      return false
    }
    if remark.isEmpty {
      showHint("备注不能为空")
      return false
    }
    if remark.length > 6 {
      showHint("备注长度超过限制")
      return false
    }
    
    return true
  }
}
