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
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  @IBAction func sendVerificationcodeButton(sender: AnyObject) {
    
    //验证手机号码合法后在发验证码并启动计时器
    if (ZKJSTool.validateMobile(userphoneTextField.text) == true) {
      HttpService.sharedInstance.requestSmsCodeWithPhoneNumber(userphoneTextField.text!) { (json, error) -> () in
        if (error == nil) {
          self.countTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "refreshCount:", userInfo: nil, repeats: true)
          self.countTimer?.fire()
          self.showHint("验证码已发送!")
          self.identifyingCodeTextField.becomeFirstResponder()
        } else {
       
        }
      }

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
    HttpService.sharedInstance.loginWithPhone(self.identifyingCodeTextField.text!, phone: self.userphoneTextField.text!) { (json, error) -> () in
      if let error = error {
        if error.code == 11 {//还未完善用户资料就跳转到用户资料完善页面
        self.navigationController?.pushViewController(SetUpVC(), animated: true)
        } else {
          self.hideHUD()
          self.showErrorHint(error)
        }
      } else {
        HttpService.sharedInstance.getUserInfo({ (json, error) -> Void in
          print(json)
          if let error = error {
            self.showErrorHint(error)
          } else {
            self.hideHUD()
            self.dismissViewControllerAnimated(true, completion: nil)
          }
        })
      }
    }

  }
  
  func unregisterYunBaTopic() {
    let locid = AccountInfoManager.sharedInstance.beaconLocationIDs
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
    let userID = TokenPayload.sharedInstance.userID
    print("Username: \(userID)")
    print("登陆前环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(userID, password: "12345",completion: { (loginInfo, err) in
        print("登陆后环信:\(loginInfo)")
        if err == nil {
          EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
          let options = EaseMob.sharedInstance().chatManager.pushNotificationOptions
          options.displayStyle = .ePushNotificationDisplayStyle_simpleBanner
          EaseMob.sharedInstance().chatManager.asyncUpdatePushOptions(options)
        }
        
      }, onQueue: dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0))
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
