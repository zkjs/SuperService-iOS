//
//  NameVC.swift
//  SVIP
//
//  Created by Hanton on 12/16/15.
//  Copyright © 2015 zkjinshi. All rights reserved.
//

import UIKit

class NameVC: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("NameVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "修改姓名"
    nameTextField.text = AccountManager.sharedInstance().userName
  }
  
  // MARK: - Gesture
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    
    view.endEditing(true)
  }
  
  @IBAction func done(sender: AnyObject) {
    guard let userName = nameTextField.text else { return }
    if userName.isEmpty == true {
      showHint("姓名不能为空")
      return
    }
    if !userName.isValidName {
      showHint("填写不合符规范，请填写真实姓名")
      return
    }
    if userName.characters.count > 12 {
      showHint("姓名不超过12个中文字符")
      return
    }
    
    HttpService.sharedInstance.updateUserInfo(false, realname: userName, eamil:nil,sex: nil, image: nil, completionHandler: {[unowned self] (json, error) -> Void in
      if let _ = error {
        self.showHint("修改姓名失败")
      } else {
        AccountManager.sharedInstance().saveUserName(userName)
        self.navigationController?.popViewControllerAnimated(true)
      }
    })

  } 
}


extension NameVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
  
}