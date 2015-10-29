//
//  StaffLoginVC.swift
//  SuperService
//
//  Created by AlexBang on 15/10/29.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class StaffLoginVC: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var verificationCodeButton: UIButton!
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var identifyingCodeTextField: UITextField!
  @IBOutlet weak var userphoneTextField: UITextField!
  @IBOutlet weak var userImage: UIImageView!
  
  var buttonTitle:UIButton?
  var countTimer:NSTimer?
  var count:Int16?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      userphoneTextField.keyboardType = UIKeyboardType.NumberPad
      identifyingCodeTextField.keyboardType = UIKeyboardType.NumberPad
      identifyingCodeTextField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
    
  @IBAction func sendVerificationcodeButton(sender: AnyObject) {
    
    if (ZKJSTool.validateMobile(userphoneTextField.text) == true) {
      ZKJSHTTPSMSSessionManager.sharedInstance().requestSmsCodeWithPhoneNumber(userphoneTextField.text) { (success: Bool, error: NSError!) -> Void in
        if (success == true) {
          self.count = 30
          self.countTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshCount:", userInfo: nil, repeats: true)
          ZKJSTool.showMsg("验证码已发送!")
          self.identifyingCodeTextField.becomeFirstResponder()
          
        }
      }
    }else {
      ZKJSTool.showMsg("请输入正确的手机号码")
    }
    
  }
  
  func refreshCount(sender:UIButton) {
    verificationCodeButton.setTitle("\(count)秒", forState: .Disabled)
    
  }
  //MARK - textField Notification
  
  @IBAction func staffCheckoutLoginButton(sender: AnyObject) {
    ZKJSHTTPSMSSessionManager.sharedInstance().verifySmsCode(self.identifyingCodeTextField.text, mobilePhoneNumber: self.userphoneTextField.text) { (success:Bool, error:NSError!) -> Void in
      if (success == true) {
        ZKJSHTTPSessionManager.sharedInstance().loginWithphoneNumber(self.userphoneTextField.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          if let dict = responseObject as? NSDictionary {
            if let set = dict["set"] as? Bool {
              if set {
                // 缓存用户信息
                AccountManager.sharedInstance().saveAccountWithDict(dict as! [String: AnyObject])
                self.view.endEditing(true)
                ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
                self.dismissViewControllerAnimated(true, completion: nil)
                
              } else {
                if let err = dict["err"] as? NSNumber {
                  if err.longLongValue == 406 {
                    ZKJSTool.showMsg("手机号还不是服务员")
                  }
                }
              }
            }
          }
          }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            
        }

      }
    }
    
}

  @IBAction func bussinessManButton(sender: AnyObject) {
    let vc = AdminLoginV()
   navigationController?.pushViewController(vc, animated: true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    return true
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
