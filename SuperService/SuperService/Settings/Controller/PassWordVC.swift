//
//  PassWordVC.swift
//  SuperService
//
//  Created by AlexBang on 16/5/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class PassWordVC: UIViewController {

  @IBOutlet weak var retracementOldBtn: UIButton!
  @IBOutlet weak var retracementbtn: UIButton!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var newPassword: UITextField!
  @IBOutlet weak var accountLabel: UILabel!
  var oldPassword:String!
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "设置密码"

      // Do any additional setup after loading the view.
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("PassWordVC", owner:self, options:nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    retracementbtn.hidden = true
    retracementOldBtn.hidden = true
    accountLabel.text = "商家账号:  \(AccountInfoManager.sharedInstance.userName)"
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
    
 
  @IBAction func retracement(sender: AnyObject) {
    newPassword.text = ""
  }

  @IBAction func retracementPassword(sender: AnyObject) {
    password.text = ""
  }
  @IBAction func changPassword(sender: AnyObject) {
    guard let a = newPassword.text,let b = password.text where a.trim.isEmpty == false && b.trim.isEmpty == false else {
      return
    }
    if a == oldPassword {
      self.alertView("新原密码与原密码不能重复")
      return
    }
    if a != b {
      self.alertView("两次输入的密码不一致")
      return
    }
    if !a.isValidPassword {
      self.alertView("密码必须是8位以上的英文字母和数字的组合")
      return
    }
    
    
    HttpService.sharedInstance.userChangePassword(oldPassword, newpassword: a) { (json, error) -> Void in
      if let error = error {
        self.showHint(error.userInfo["resDesc"] as! String)
      }else {
        let vc = ChangePasswordSuccessVC()
        vc.modalPresentationStyle = .Custom
        self.presentViewController(vc, animated: true, completion: nil)
        delay(1, closure: { () -> () in
          vc.dismissViewControllerAnimated(true, completion: nil)
          self.navigationController?.popViewControllerAnimated(true)
        })
        
      }
    }
  }
  
  func alertView(title:String) {
    let alertController = UIAlertController(title: title, message: "", preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
    let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
    }
    alertController.addAction(checkAction)
    self.presentViewController(alertController, animated: true, completion: nil)
    
  }

}

extension PassWordVC:UITextFieldDelegate {
  func textFieldShouldClear(textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if ((newPassword.text?.trim.isEmpty) != nil) {
      retracementbtn.hidden = false
      retracementOldBtn.hidden = false
    }
  }
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    newPassword.endEditing(true)
    retracementbtn.hidden = true
    retracementOldBtn.hidden = true
   return true 
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    password.becomeFirstResponder()
    newPassword.endEditing(true)
    retracementbtn.hidden = true
    retracementOldBtn.hidden = true
    return true
  }
  
}
