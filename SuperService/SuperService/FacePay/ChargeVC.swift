//
//  ChargeVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit
typealias PayResultDismissClosure = (Bool,payResult:FacePayResult) ->Void

class ChargeVC: UIViewController {
  var customer: NearbyCustomer!
  var payResult: FacePayResult?
  var payResultClosure: PayResultDismissClosure?
  
  @IBOutlet weak var payFaliLabe: UILabel!
  @IBOutlet weak var avatarsImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var moneyField: UITextField!
  @IBOutlet weak var confirmButton: UIButton!
  
  override func viewDidLoad() {
    self.title = "收款金额"
    setupView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    moneyField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(animated: Bool) {
    view.endEditing(true)
  }
  
  private func setupView() {
    avatarsImageView.layer.borderColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).CGColor
    avatarsImageView.layer.borderWidth = 2
    avatarsImageView.sd_setImageWithURL(NSURL(string: customer.userimage), placeholderImage: UIImage(named: ""))
    nameLabel.text = customer.username
    payFaliLabe.hidden = true
    
  }
  
  
  @IBAction func confirmButtonTapped(sender: UIButton) {
    guard let money = moneyField.text else {
      self.showHint("请输入金额")
      return
    }
    if !money.isDecimal {
      self.showHint("请输入正确金额")
      return
    }
    guard let amount = Double(moneyField.text!) else {return}
    confirmButton.enabled = false
    self.showHUDInView(view, withLoading: "")
    HttpService.sharedInstance.chargeCustomer(amount, userid: customer.userid, orderNo: nil) { (orderno, error) -> Void in
      self.confirmButton.enabled = true
      self.hideHUD()
      if let orderno = orderno {
        self.payResult = FacePayResult(customer:self.customer, amount: amount, succ: 1, orderNo: orderno, errorCode: 0, waiting: amount > 100,confirmTime:nil,createTime:nil)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
          if let closure = self.payResultClosure {
            closure(true, payResult:self.payResult!)
          }
        })
                
      } else {
        if error?.code == 30101 {//余额不足
          self.payFaliLabe.hidden = false
          self.showHint("余额不足")
        } else {//错误
          self.showErrorHint(error)
        }
      }
    }
  }
  
  @IBAction func disMiss(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  
}
