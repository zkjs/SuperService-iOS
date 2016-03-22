//
//  ChargeVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class ChargeVC: UIViewController {
  var customer: NearbyCustomer!
  var payResult: FacePayResult?
  
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
    avatarsImageView.sd_setImageWithURL(NSURL(string: customer.userimage), placeholderImage: UIImage(named: "avatars_default_white"))
    nameLabel.text = customer.username
    
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
    HttpService.chargeCustomer(amount, userid: customer.userid, orderNo: nil) { (orderno, error) -> Void in
      self.confirmButton.enabled = true
      if let orderno = orderno {
        self.payResult = FacePayResult(customer: self.customer, amount: amount, succ: true, orderNo: orderno, errorCode: 0, waiting: amount > 100)
        self.performSegueWithIdentifier("PaymentResultSegue", sender: nil)
      } else {
        if error?.code == 30101 {//余额不足
          self.showHint("用户账户余额不足,请使用其它收款方式!")
        } else {//错误
          self.showHint("error:\(error?.code)")
        }
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PaymentResultSegue" {
      let vc = segue.destinationViewController as! PaymentResultVC
      vc.payResult = payResult
    }
  }
  
}
