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
    
    showHUDInView(view, withLoading: "")
    
    HttpService.loginWithUserName(phone, password: password.md5) { (json, error) -> () in
      
    }
    
    ZKJSHTTPSessionManager.sharedInstance().adminLoginWithPhone(phone, password: password,success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      self.hideHUD()
      print(responseObject)
      if let dict = responseObject as? NSDictionary {
        if let set = dict["set"] as? Bool {
          if set {
            self.showHUDInView(self.view, withLoading: "")
            // 缓存用户信息
            self.loginEaseMob()
            AccountManager.sharedInstance().saveAccountWithDict(dict as! [String: AnyObject])
            self.updateYunBaWithLocid(AccountManager.sharedInstance().beaconLocationIDs)
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
  
  private func loginEaseMob() {
    let userID = AccountManager.sharedInstance().userID
    let error: AutoreleasingUnsafeMutablePointer<EMError?> = nil
    print("Username: \(userID)")
    print("登陆前环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    EaseMob.sharedInstance().chatManager.loginWithUsername(userID, password: "123456", error: error)
    print("登陆后环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    if error != nil {
      showHint(error.debugDescription)
    }
    EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
    let options = EaseMob.sharedInstance().chatManager.pushNotificationOptions
    options.displayStyle = .ePushNotificationDisplayStyle_simpleBanner
    EaseMob.sharedInstance().chatManager.asyncUpdatePushOptions(options)
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
      // 密码最多20位
      if range.location + string.characters.count <= 20 {
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

extension String {
  var md5 : String{
    let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
    
    CC_MD5(str!, strLen, result);
    
    let hash = NSMutableString();
    for i in 0 ..< digestLen {
      hash.appendFormat("%02x", result[i]);
    }
    result.destroy();
    
    return String(format: hash as String)
  }
}

