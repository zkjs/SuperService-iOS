//
//  SendSuccessVC.swift
//  SuperService
//
//  Created by AlexBang on 16/3/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
typealias SendSuccessVCDismissClosure = (Bool) ->Void
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func disMiss(sender: AnyObject) {

    self.dismissViewControllerAnimated(true, completion: nil)
  }
  @IBAction func endSend(sender: AnyObject) {
    self.dismissViewControllerAnimated(true) { () -> Void in
      if let closure = self.sendSuccessClosure {
        closure(true)
      }
    }
    
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
