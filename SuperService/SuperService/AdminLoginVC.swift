//
//  AdminLoginVC.swift
//  SuperService
//
//  Created by Hanton on 9/30/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class AdminLoginVC: UIViewController {
  
  @IBOutlet weak var phoneTextField: LTBouncyTextField!
  @IBOutlet weak var passwordTextField: LTBouncyTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    phoneTextField.alwaysBouncePlaceholder = true
    phoneTextField.abbreviatedPlaceholder = "手机号码"
    passwordTextField.alwaysBouncePlaceholder = true
    passwordTextField.abbreviatedPlaceholder = "密码"
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  // MARK: - Private Method
  
  func isMobileNumber(phone: NSString) -> Bool {
    /**
    * 手机号码
    * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    * 联通：130,131,132,152,155,156,185,186
    * 电信：133,1349,153,180,189
    */
    let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    /**
    * 中国移动：China Mobile
    * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    */
    let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    /**
    * 中国联通：China Unicom
    * 130,131,132,152,155,156,185,186
    */
    let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    /**
    * 中国电信：China Telecom
    * 133,1349,153,180,189
    */
    let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    /**
    * 虚拟运营商 170
    */
    let VO = "^1(7[0-9])\\d{8}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
    let regexCM = NSPredicate(format: "SELF MATCHES %@", CM)
    let regexCU = NSPredicate(format: "SELF MATCHES %@", CU)
    let regexCT = NSPredicate(format: "SELF MATCHES %@", CT)
    let regexVO = NSPredicate(format: "SELF MATCHES %@", VO)
    let isPhone = regexMobile.evaluateWithObject(phone)
      || regexCM.evaluateWithObject(phone)
      || regexCU.evaluateWithObject(phone)
      || regexCT.evaluateWithObject(phone)
      || regexVO.evaluateWithObject(phone)
    
    return isPhone
  }
  
  // MARK: - Button Action
  
  @IBAction func tappedLoginButton(sender: AnyObject) {
    guard let phone = phoneTextField.text else {
      ZKJSTool.showMsg("请输入手机号码")
      return
    }
    
    if !isMobileNumber(phone as NSString) {
      ZKJSTool.showMsg("请输入正确的手机格式")
      return
    }
    
    guard let password = passwordTextField.text else {
      ZKJSTool.showMsg("请输入密码")
      return
    }
    
    // 14000800924:123456
    ZKJSHTTPSessionManager.sharedInstance().adminLoginWithPhone(phone, password: password, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let dict = responseObject as? NSDictionary {
        if let set = dict["set"] as? Bool {
          if set {
            // 缓存用户信息
            AccountManager.sharedInstance().saveAccountWithDict(dict)
            self.dismissViewControllerAnimated(true, completion: nil)
          } else {
            if let err = dict["err"] as? NSNumber {
              if err.longLongValue == 408 {
                ZKJSTool.showMsg("密码或者手机号不正确")
              }
            }
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
}

extension AdminLoginVC: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == phoneTextField {
      // 电话号码11位
      if range.location + string.characters.count <= 11 {
        return true
      }
    } else if textField == passwordTextField {
      // 验证码6位
      if range.location + string.characters.count <= 6 {
        return true
      }
    }
    return false
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == phoneTextField {
      
    } else if textField == passwordTextField {
      
    }
  }
  
}
