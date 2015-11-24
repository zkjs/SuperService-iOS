//
//  AdminLoginV.swift
//  SuperService
//
//  Created by AlexBang on 15/10/29.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class AdminLoginV: UIViewController {
  
  @IBOutlet weak var passwordTextField: LTBouncyTextField!
  @IBOutlet weak var userphoneTextField: LTBouncyTextField!
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AdminLoginV", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "商家登录"
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }

  
  // MARK: - Button Action
  
  @IBAction func tappedLoginButton(sender: AnyObject) {
    guard let phone = userphoneTextField.text else { return }
    
    if phone.isEmpty == true {
      showHint("请输入手机号码")
      return
    }
    
    guard let password = passwordTextField.text else {
      showHint("请输入密码")
      return
    }
    
    // 14000800924:123456
    ZKJSHTTPSessionManager.sharedInstance().adminLoginWithPhone(phone, password: password,success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let dict = responseObject as? NSDictionary {
        if let set = dict["set"] as? Bool {
          if set {
            // 缓存用户信息
            AccountManager.sharedInstance().saveAccountWithDict(dict as! [String: AnyObject])
            // 环信账号自动登录
            AccountManager.sharedInstance().easeMobAutoLogin()
            self.view.endEditing(true)
            ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
            self.dismissViewControllerAnimated(true, completion: nil)
          } else {
            if let err = dict["err"] as? NSNumber {
              if err.longLongValue == 408 {
                self.showHint("密码或者手机号不正确")
              }
            }
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  
}

extension AdminLoginV: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == userphoneTextField {
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
  
}

