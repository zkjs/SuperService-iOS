//
//  SendSuccessVC.swift
//  SuperService
//
//  Created by AlexBang on 16/3/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
typealias SendSuccessVCDismissClosure = (Bool,orderno:String) ->Void
class SendSuccessVC: UIViewController {

  @IBOutlet weak var endSendButton: UIButton!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  var payResult:FacePayResult!
  var sendSuccessClosure:SendSuccessVCDismissClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
      amountLabel.text = "￥\((payResult.amount).format(".2"))"
      statusLabel.text = "等待 \(payResult.customer.username) 确认"
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushToPaymentResult:", name:kRefreshPayResultVCNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name:kYBDidReceiveMessageNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func pushToPaymentResult(notification:NSNotification) {
    self.dismissViewControllerAnimated(true) { () -> Void in
      guard let userInfo = notification.userInfo,let payInfo = userInfo["payInfo"] as? FacePayPushResult  else {
        return
      }
      
//      self.payResult = FacePayResult(customer:payInfo.custom, amount: payInfo.amount/100, succ: payInfo.status, orderNo: payInfo.orderno, errorCode: 0, waiting: payInfo.amount > 100,confirmTime:nil,createTime:payInfo.createtime)
      if let closure = self.sendSuccessClosure {
        closure(true,orderno: payInfo.orderno)
      }
    }
  }
    
  @IBAction func disMiss(sender: AnyObject) {

    self.dismissViewControllerAnimated(true, completion: nil)
  }
  @IBAction func endSend(sender: AnyObject) {
    self.dismissViewControllerAnimated(true) { () -> Void in
      if let closure = self.sendSuccessClosure {
        closure(true,orderno: "")
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
        self.payResult = FacePayResult(customer:result.custom, amount: result.amount/100, succ: result.status, orderNo: result.orderno, errorCode: 0, waiting: result.amount > 100,confirmTime:nil,createTime:result.createtime)
        
        
        self.dismissViewControllerAnimated(true) { () -> Void in
          if let closure = self.sendSuccessClosure {
            closure(true,orderno: result.orderno)
          }
        }
      }
    }
  }

}
