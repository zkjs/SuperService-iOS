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
  var pushResult:FacePayPushResult?

  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var refusedLabel: UILabel!
  @IBOutlet weak var sendAgainButton: UIButton!
  @IBOutlet weak var orderNoLabel: UILabel!
  @IBOutlet weak var createdTimeLabel: UILabel!
  @IBOutlet weak var confirmTimeLabel: UILabel!
  
  override func viewDidLoad() {
    self.title = "收款结果"
    setupView()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name:kYBDidReceiveMessageNotification, object: nil)
  }
  
  private func setupView() {
    if payResult.success {
      amountLabel.text = "￥\(payResult.amount)"
      if let orderNo = payResult.orderNo {
        orderNoLabel.text = "交易单号：\(orderNo)"
      }
      createdTimeLabel.text = "收款时间：\(NSDate().formatted)"
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
  
  private func updateView(){
    guard let pushResult = pushResult else {
      return
    }
    
    if pushResult.status == 2 {// 2 - 用户已确认付款,
      if pushResult.userid == payResult.customer.userid {
        statusLabel.text = "\(payResult.customer.username) 收款成功"
        confirmTimeLabel.text = "成功时间：\(NSDate().formatted)"
        confirmTimeLabel.hidden = false
        sendAgainButton.hidden = true
        refusedLabel.hidden = true
      }
    } else if pushResult.status == 1 {//1 - 用户拒绝付款
      if pushResult.userid == payResult.customer.userid {
        statusLabel.text = "\(payResult.customer.username) 收款失败"
        confirmTimeLabel.text = "失败时间：\(NSDate().formatted)"
        refusedLabel.text = "用户拒绝支付"
        confirmTimeLabel.hidden = false
        refusedLabel.hidden = false
        sendAgainButton.hidden = false
        showHint("用户拒绝支付")
      }
    }
  }
  
  func onMessageReceived(notification: NSNotification) {
    if let message = notification.object as? YBMessage {
      let payloadString = String(data: message.data, encoding: NSUTF8StringEncoding)
      print("[message] \(message.topic) => \(payloadString)")
      let json = JSON(data: message.data)
      if json["type"].string == "PAYMENT_RESULT" {
        let result = FacePayPushResult(json: json["data"])
        self.pushResult = result
        self.updateView()
      }
    }
  }
  
  @IBAction func sendAgain(sender: UIButton) {
    
    let alertController = UIAlertController(title: "提示", message: "是否重新发起收款请求?", preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
    let okAction = UIAlertAction(title: "确认", style: .Default) { (action) -> Void in
      self.chargeAgain()
    }
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func chargeAgain() {
    self.sendAgainButton.enabled = false
    HttpService.chargeCustomer(payResult.amount, userid: payResult.customer.userid, orderNo: payResult.orderNo) { (orderno, error) -> Void in
      self.sendAgainButton.enabled = true
      if let _ = orderno {
        
      } else {
        if error?.code == 30101 {//余额不足
          self.showHint("用户账户余额不足,请使用其它收款方式!")
        } else if error?.code == 30102 {//重发过于频繁
          self.showHint("重发过于频繁,请1小时后再试")
        } else {//错误
          self.showHint("error:\(error?.code)")
        }
      }
    }
  }
  
}
