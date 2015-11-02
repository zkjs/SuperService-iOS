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
  
  @IBOutlet weak var loginButton: UIButton! {
    didSet {
      loginButton.layer.masksToBounds = true
      loginButton.layer.cornerRadius = 20
    }
  }

  @IBOutlet weak var identifyingCodeTextField: UITextField!
  @IBOutlet weak var userphoneTextField: UITextField!
  @IBOutlet weak var userImage: UIImageView!
  
  var buttonTitle:UIButton?
  var countTimer:NSTimer?
  var count:Int = 30
  
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "登录"
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
    //验证手机号码合法后在发验证码并启动计时器
    if (ZKJSTool.validateMobile(userphoneTextField.text) == true) {
      ZKJSHTTPSMSSessionManager.sharedInstance().requestSmsCodeWithPhoneNumber(userphoneTextField.text) { (success: Bool, error: NSError!) -> Void in
        if (success == true) {
          self.countTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshCount:", userInfo: nil, repeats: true)
          self.countTimer?.fire()
            ZKJSTool.showMsg("验证码已发送!")
          self.identifyingCodeTextField.becomeFirstResponder()
          
        }
      }
    }else {
      ZKJSTool.showMsg("请输入正确的手机号码")
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
                
                ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
                let url = AccountManager.sharedInstance().url
                if url == "" {
                  let setVC = SetUpVC()
                  self.navigationController?.pushViewController(setVC, animated: true)
                } else {
                  self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
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

}

extension StaffLoginVC: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == userphoneTextField {
      // 电话号码11位
      if range.location + string.characters.count <= 11 {
        verificationCodeButton.backgroundColor = UIColor(hexString: "29B6F6")
        return true
      }
    } else if textField == identifyingCodeTextField {
      // 验证码6位
      if range.location + string.characters.count <= 6 {
        loginButton.backgroundColor = UIColor(hexString: "29B6F6")
        return true
      }
    }
    return false
  }
  
}
