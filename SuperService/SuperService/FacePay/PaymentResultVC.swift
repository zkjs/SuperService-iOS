//
//  PaymentResultVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit
enum pushType {
  case Charge
  case PaymentList
}

class PaymentResultVC: UIViewController {
  var payResult:FacePayResult!
  var pushResult:FacePayPushResult?
  var type:pushType?
  

  @IBOutlet weak var statusImage: UIImageView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var refusedLabel: UILabel!
  @IBOutlet weak var sendAgainButton: UIButton!
  @IBOutlet weak var orderNoLabel: UILabel!
  @IBOutlet weak var createdTimeLabel: UILabel!
  @IBOutlet weak var confirmTimeLabel: UILabel!
  
  @IBOutlet weak var statusResultLabel: UILabel!
  @IBOutlet weak var endsendButton: UIButton!
  override func viewDidLoad() {
    self.title = "收款结果"
    
    
    let backButton = UIBarButtonItem(image: UIImage(named: "ic_fanhui_orange"), style: UIBarButtonItemStyle.Plain, target: self, action: "goBackToCounterVC")
    self.navigationItem.leftBarButtonItem = backButton
    
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    self.updateView()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name:kYBDidReceiveMessageNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshPayResult:", name:kRefreshPayResultVCNotification, object: nil)
    
  }
  
  func goBackToCounterVC() {
    if let toVC = self.navigationController?.viewControllers[0] {
      self.navigationController?.popToViewController(toVC, animated: true)
    } else {
      self.navigationController?.popViewControllerAnimated(true)
    }

  }
  
//  private func setupView() {
//    amountLabel.text = "￥\((payResult.amount).format(".2"))"
//    statusLabel.text = "发送成功!\n等待 \(payResult.customer.username) 确认"
//    orderNoLabel.hidden = true
//    confirmTimeLabel.hidden = true
//    createdTimeLabel.hidden = true
//    sendAgainButton.hidden = true
//  }
  
  private func updateView(){
    if payResult.status == 0 {// 0 - 等待用户确认付款,
      statusImage.image = UIImage(named: "ic_dengdai")
      statusLabel.text = " \(payResult.customer.username)"
      statusResultLabel.text = "等待确认"
      if let paymentNo = payResult.paymentNo,let createTime = payResult.createTime {
        orderNoLabel.text = "交易单号:\(paymentNo)"
        createdTimeLabel.text = "收款时间:\(createTime)"
      }
      amountLabel.text = "￥\((payResult.amount).format(".2"))"
      confirmTimeLabel.hidden = true
      sendAgainButton.hidden = false
      endsendButton.hidden = true
      refusedLabel.hidden = true
    } 
    if payResult.status == 2 {// 2 - 用户已确认付款,
      statusImage.image = UIImage(named: "ic_chenggong")
      statusLabel.text = "\(payResult.customer.username)"
      statusResultLabel.text = " 收款成功"
      amountLabel.text = "￥\((payResult.amount).format(".2"))"
    if  let paymentNo = payResult.paymentNo,
        let confirm = payResult.confirmTime,
        let createTime = payResult.createTime {
        orderNoLabel.text = "交易单号:\(paymentNo)"
        confirmTimeLabel.text = "成功时间:\(confirm)"
        createdTimeLabel.text = "收款时间:\(createTime)"
      }
      confirmTimeLabel.hidden = false
      sendAgainButton.hidden = true
      endsendButton.hidden = true
      refusedLabel.hidden = true
    } else if payResult.status == 1 {//1 - 用户拒绝付款
      statusImage.image = UIImage(named: "ic_shibai")
      statusLabel.text = "\(payResult.customer.username)"
      statusResultLabel.text = " 收款失败"
      amountLabel.text = "￥\((payResult.amount).format(".2"))"
      confirmTimeLabel.hidden = false
      if let paymentNo = payResult.paymentNo,let confirm = payResult.confirmTime,let createTime = payResult.createTime {
        orderNoLabel.text = "交易单号:\(paymentNo)"
        confirmTimeLabel.text = "失败时间:\(confirm)"
        createdTimeLabel.text = "收款时间:\(createTime)"
      }
      
      refusedLabel.text = "用户拒绝支付"
      refusedLabel.hidden = false
      sendAgainButton.hidden = false
      endsendButton.hidden = true
      
      }
  }
  
  func refreshPayResult(notification: NSNotification) {
    guard let userInfo = notification.userInfo,let payInfo = userInfo["payInfo"] as? FacePayPushResult  else {
      return
    }
    self.payResult = FacePayResult(customer:payInfo.custom, amount: payInfo.amount/100, succ: payInfo.status, orderNo: payInfo.orderno,paymentNo:payInfo.paymentno, errorCode: 0, waiting: payInfo.amount > 100,confirmTime:nil,createTime:payInfo.createtime)
    self.updateView()
  }
  
  func onMessageReceived(notification: NSNotification) {
    if let message = notification.object as? YBMessage {
      let payloadString = String(data: message.data, encoding: NSUTF8StringEncoding)
      print("[message] \(message.topic) => \(payloadString)")
      let json = JSON(data: message.data)
      if json["type"].string == "PAYMENT_RESULT" {
        let result = FacePayPushResult(json: json["data"])
        self.payResult = FacePayResult(customer:result.custom, amount: result.amount/100, succ: result.status, orderNo: result.orderno,paymentNo:result.paymentno, errorCode: 0, waiting: result.amount > 100,confirmTime:nil,createTime:result.createtime)
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
    HttpService.sharedInstance.chargeCustomer(payResult.amount, userid: payResult.customer.userid, orderNo: payResult.orderNo) { (json, error) -> Void in
      self.sendAgainButton.enabled = true
      if let error = error {
        if error.code == 30101 {//余额不足
          self.showHint("用户账户余额不足,请使用其它收款方式!")
        } else if error.code == 30102 {//重发过于频繁
          self.showHint("重发过于频繁,请1小时后再试")
        } else {//错误
          self.showHint("error:\(error.code)")
        }
      } else {
        self.showHint("请求发送成功")
      }
    }
  }
  

    
  
}
