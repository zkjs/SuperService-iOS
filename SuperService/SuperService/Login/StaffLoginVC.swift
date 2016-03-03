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
  @IBOutlet weak var identifyingCodeTextField: LTBouncyTextField!
  @IBOutlet weak var userphoneTextField: LTBouncyTextField!
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
    
    userphoneTextField.alwaysBouncePlaceholder = true
    userphoneTextField.abbreviatedPlaceholder = "手机号"
    
    identifyingCodeTextField.alwaysBouncePlaceholder = true
    identifyingCodeTextField.abbreviatedPlaceholder = "验证码"
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    unregisterYunBaTopic()
    checkVersion()
  }
  
  func checkVersion() {
    let buildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    let version = NSNumber(longLong: Int64(buildNumber)!)
    ZKJSJavaHTTPSessionManager.sharedInstance().checkVersionWithVersion(version, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let isForceUpgrade = responseObject["isForceUpgrade"] as? NSNumber {
        if isForceUpgrade.integerValue == 0 {
          // hmmm...
        } else if isForceUpgrade.integerValue == 1 {
          // 提示更新
          if let versionNo = responseObject["versionNo"] as? NSNumber {
            if versionNo.longLongValue > version.longLongValue {
              let alertController = UIAlertController(title: "升级提示", message: "已有新版本可供升级", preferredStyle: .Alert)
              let upgradeAction = UIAlertAction(title: "升级", style: .Default, handler: { (action: UIAlertAction) -> Void in
                let url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/chao-ji-fu-wu/id1048366534?ls=1&mt=8")
                if UIApplication.sharedApplication().canOpenURL(url!) {
                  UIApplication.sharedApplication().openURL(url!)
                }
              })
              alertController.addAction(upgradeAction)
              let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
              alertController.addAction(cancelAction)
              self.presentViewController(alertController, animated: true, completion: nil)
            }
          }
        } else if isForceUpgrade.integerValue == 2 {
          // 强制更新
          if let versionNo = responseObject["versionNo"] as? NSNumber {
            if versionNo.longLongValue > version.longLongValue {
              let alertController = UIAlertController(title: "升级提示", message: "请您升级到最新版本，以保证软件的正常使用", preferredStyle: .Alert)
              let upgradeAction = UIAlertAction(title: "升级", style: .Default, handler: { (action: UIAlertAction) -> Void in
                let url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/chao-ji-fu-wu/id1048366534?ls=1&mt=8")
                if UIApplication.sharedApplication().canOpenURL(url!) {
                  UIApplication.sharedApplication().openURL(url!)
                }
              })
              alertController.addAction(upgradeAction)
              self.presentViewController(alertController, animated: true, completion: nil)
            }
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  @IBAction func sendVerificationcodeButton(sender: AnyObject) {
    
    //验证手机号码合法后在发验证码并启动计时器
    if (ZKJSTool.validateMobile(userphoneTextField.text) == true) {
      HttpService.requestSmsCodeWithPhoneNumber(userphoneTextField.text!) { (json, error) -> () in
        if (error == nil) {
          self.countTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshCount:", userInfo: nil, repeats: true)
          self.countTimer?.fire()
          self.showHint("验证码已发送!")
          self.identifyingCodeTextField.becomeFirstResponder()
        } else {
       
        }
      }
//      ZKJSHTTPSMSSessionManager.sharedInstance().requestSmsCodeWithPhoneNumber(userphoneTextField.text) { (success: Bool, error: NSError!) -> Void in
//        if (success == true) {
//          self.countTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshCount:", userInfo: nil, repeats: true)
//          self.countTimer?.fire()
//          self.showHint("验证码已发送!")
//          self.identifyingCodeTextField.becomeFirstResponder()
//        } else {
//          if let userInfo = error.userInfo.first {
//            self.showHint(userInfo.1 as! String)
//          }
//        }
//      }
//    } else {
//      self.showHint("请输入正确的手机号码")
//    }
    }
  }
  
  func refreshCount(sender:UIButton) {
    count--
    verificationCodeButton.setTitle("\(count)", forState:.Normal)
    if (count == 0) {
      verificationCodeButton.setTitle("验证码", forState: .Normal)
      count = 30
      self.countTimer?.invalidate()
      self.countTimer = nil
    }
  }
  
  
  @IBAction func staffCheckoutLoginButton(sender: AnyObject) {
    login()
  }
  
  func login() {
    showHUDInView(view, withLoading: "")
    //////登录获取新的token
    HttpService.loginWithPhone(self.identifyingCodeTextField.text!, phone: self.userphoneTextField.text!) { (json, error) -> () in
      
    }
    ZKJSHTTPSMSSessionManager.sharedInstance().verifySmsCode(self.identifyingCodeTextField.text, mobilePhoneNumber: self.userphoneTextField.text) { (success:Bool, error:NSError!) -> Void in
      if (success == true) {
        //当验证码接收到后按钮恢复状态
        self.verificationCodeButton.setTitle("验证码", forState: UIControlState.Normal)
        ZKJSHTTPSessionManager.sharedInstance().loginWithphoneNumber(self.userphoneTextField.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          //          print(responseObject)
          if let dict = responseObject as? NSDictionary {
            if let set = dict["set"] as? Bool {
              if set {
                // 缓存用户信息
                AccountManager.sharedInstance().saveAccountWithDict(dict as! [String: AnyObject])
                self.loginEaseMob()
                self.updateYunBaWithLocid(AccountManager.sharedInstance().beaconLocationIDs)
                ZKJSJavaHTTPSessionManager.sharedInstance().getShopDetailWithShopID(AccountManager.sharedInstance().shopID, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                  print(responseObject)
                  if let category = responseObject["category"] as? String {
                    AccountManager.sharedInstance().saveCategory(category)
                    let url = AccountManager.sharedInstance().url
                    if url.isEmpty {
                      // 第一次登录，需要设置一下
                      let setVC = SetUpVC()
                      self.navigationController?.pushViewController(setVC, animated: true)
                    } else {
                      self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    self.hideHUD()
                  }
                  }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                    self.hideHUD()
                })
              } else {
                if let err = dict["err"] as? NSNumber {
                  if err.integerValue == 406 {
                    self.hideHUD()
                    self.showHint("手机号还不是服务员")
                  }
                }
              }
            }
          }
          }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            
        }
      } else {
        self.hideHUD()
        self.showHint("验证码不正确")
      }
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
  
  func unregisterYunBaTopic() {
    let locid = AccountManager.sharedInstance().beaconLocationIDs
    let topicArray = locid.componentsSeparatedByString(",")
    for topic in topicArray {
      YunBaService.unsubscribe(topic) { (success: Bool, error: NSError!) -> Void in
        if success {
          print("[result] unsubscribe to topic(\(topic)) succeed")
        } else {
          print("[result] unsubscribe to topic(\(topic)) failed: \(error), recovery suggestion: \(error.localizedRecoverySuggestion)")
        }
      }
    }
  }
  
  private func loginEaseMob() {
    let userID = AccountManager.sharedInstance().userID
    print("Username: \(userID)")
    let error: AutoreleasingUnsafeMutablePointer<EMError?> = nil
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
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    login()
    return true
  }
  
}
