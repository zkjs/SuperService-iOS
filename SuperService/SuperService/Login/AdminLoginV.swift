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
    
    passwordTextField.alwaysBouncePlaceholder = true
    passwordTextField.abbreviatedPlaceholder = "密码"
    
    userphoneTextField.alwaysBouncePlaceholder = true
    userphoneTextField.abbreviatedPlaceholder = "用户名"
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }

  
  // MARK: - Button Action
  
  @IBAction func tappedLoginButton(sender: AnyObject) {
    login()
  }
  
  func login() {
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
    showHUDInView(view, withLoading: "")
    ZKJSHTTPSessionManager.sharedInstance().adminLoginWithPhone(phone, password: password,success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      self.hideHUD()
      print(responseObject)
      if let dict = responseObject as? NSDictionary {
        if let set = dict["set"] as? Bool {
          if set {
            // 缓存用户信息
            self.easeMobAutoLogin()
            AccountManager.sharedInstance().saveAccountWithDict(dict as! [String: AnyObject])
            self.updateYunBaWithLocid(AccountManager.sharedInstance().beaconLocationIDs)
            self.showHUDInView(self.view, withLoading: "")
            ZKJSJavaHTTPSessionManager.sharedInstance().getShopDetailWithShopID(AccountManager.sharedInstance().shopID, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
              self.hideHUD()
              print(responseObject)
              if let category = responseObject["category"] as? String {
                AccountManager.sharedInstance().saveCategory(category)
                self.view.endEditing(true)
                self.dismissViewControllerAnimated(true, completion: nil)
              }
              }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                
            })
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
  
  private func easeMobAutoLogin() {
    // 自动登录
    let isAutoLogin = EaseMob.sharedInstance().chatManager.isAutoLoginEnabled
    if isAutoLogin == false {
      let userID = AccountManager.sharedInstance().userID
      EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(userID, password: "123456", completion: { (responseObject: [NSObject : AnyObject]!, error: EMError!) -> Void in
        EaseMob.sharedInstance().chatManager.enableAutoLogin!()
        }, onQueue: nil)
    }
  }
  
  func updateYunBaWithLocid(locid: String) {
    let areaArray = locid.componentsSeparatedByString(",")
    print("areaArr: \(areaArray)")
    for topic in areaArray {
      // 选中则监听区域
      YunBaService.subscribe(topic) { (success: Bool, error: NSError!) -> Void in
        if success {
          print("[result] subscribe to topic(\(topic)) succeed")
        } else {
          print("[result] subscribe to topic(\(topic)) failed: \(error), recovery suggestion: \(error.localizedRecoverySuggestion)")
        }
      }
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
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    login()
    return true
  }
  
}

