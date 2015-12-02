//
//  StaffLoginVC.swift
//  SuperService
//
//  Created by AlexBang on 15/10/29.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit


class StaffLoginVC: UIViewController {
  
  @IBOutlet weak var verificationCodeButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var identifyingCodeTextField: UITextField!
  @IBOutlet weak var userphoneTextField: UITextField!
  @IBOutlet weak var userImage: UIImageView!
  
  var buttonTitle:UIButton?
  var countTimer:NSTimer?
  var count:Int = 30
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("StaffLoginVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "登录"
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  @IBAction func sendVerificationcodeButton(sender: AnyObject) {
    //验证手机号码合法后在发验证码并启动计时器
    if (ZKJSTool.validateMobile(userphoneTextField.text) == true) {
      ZKJSHTTPSMSSessionManager.sharedInstance().requestSmsCodeWithPhoneNumber(userphoneTextField.text) { (success: Bool, error: NSError!) -> Void in
        if (success == true) {
          self.countTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshCount:", userInfo: nil, repeats: true)
          self.countTimer?.fire()
          self.showHint("验证码已发送!")
          self.identifyingCodeTextField.becomeFirstResponder()
        }
      }
    }else {
      self.showHint("请输入正确的手机号码")
    }
    
  }
  
  func refreshCount(sender:UIButton) {
    count--
    verificationCodeButton.setTitle("\(count)", forState:UIControlState.Normal)
    if (count == 0) {
      verificationCodeButton.setTitle("验证码", forState: UIControlState.Normal)
      count = 30
      self.countTimer?.invalidate()
      self.countTimer = nil
    }
    
  }
  
  
  @IBAction func staffCheckoutLoginButton(sender: AnyObject) {
    ZKJSHTTPSMSSessionManager.sharedInstance().verifySmsCode(self.identifyingCodeTextField.text, mobilePhoneNumber: self.userphoneTextField.text) { (success:Bool, error:NSError!) -> Void in
      print(success)
      
      if (success == true) {
        //当验证码接收到后按钮恢复状态
        self.verificationCodeButton.setTitle("验证码", forState: UIControlState.Normal)
        
        ZKJSHTTPSessionManager.sharedInstance().loginWithphoneNumber(self.userphoneTextField.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          if let dict = responseObject as? NSDictionary {
            if let set = dict["set"] as? Bool {
              if set {
                // 缓存用户信息
                AccountManager.sharedInstance().saveAccountWithDict(dict as! [String: AnyObject])
                // 环信账号自动登录
                AccountManager.sharedInstance().easeMobAutoLogin()
                ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
                let url = AccountManager.sharedInstance().url
                if url.isEmpty {
                  // 第一次登录，需要设置一下
                  let setVC = SetUpVC()
                  self.navigationController?.pushViewController(setVC, animated: true)
                }
                else {
                  self.dismissViewControllerAnimated(true, completion: nil)
                }
              } else {
                if let err = dict["err"] as? NSNumber {
                  if err.integerValue == 406 {
                    self.showHint("手机号还不是服务员")
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
}

extension StaffLoginVC: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == userphoneTextField {
      // 电话号码11位
      if range.location + string.characters.count <= 11 {
        verificationCodeButton.backgroundColor = UIColor.ZKJS_themeColor()
        return true
      }
    } else if textField == identifyingCodeTextField {
      // 验证码6位
      if range.location + string.characters.count <= 6 {
        loginButton.backgroundColor = UIColor.ZKJS_themeColor()
        return true
      }
    }
    return false
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 3.0
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.ZKJS_themeColor().CGColor
    return true
  }
  
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    textField.layer.borderWidth = 0
    return true
  }
  
}
