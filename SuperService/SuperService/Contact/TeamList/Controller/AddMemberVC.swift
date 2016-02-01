//
//  AddMemberVC.swift
//  SuperService
//
//  Created by admin on 15/10/28.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

protocol RefreshTeamListVCDelegate {
  func RefreshTeamListTableView()
}

class AddMemberVC: UIViewController, UITextFieldDelegate {
  
  var delegate: RefreshTeamListVCDelegate?
  var isUncheck = false
  var deptid = ""
  
  @IBOutlet weak var departmentLabel: UILabel!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var photoTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AddMemberVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "新建成员"
    
    departmentLabel.layer.borderColor = UIColor(white: 204.0/255.0, alpha: 1.0).CGColor
    departmentLabel.layer.borderWidth = 0.5
    departmentLabel.layer.masksToBounds = true
    departmentLabel.layer.cornerRadius = 3
    
    remarkTextView.layer.borderColor = UIColor(white: 204.0/255.0, alpha: 1.0).CGColor
    remarkTextView.layer.borderWidth = 0.5
    remarkTextView.layer.masksToBounds = true
    remarkTextView.layer.cornerRadius = 3
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  @IBAction func choiceDepartmentButton(sender: AnyObject) {
    let vc = MemberListVC()
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func sureButton(sender: AnyObject) {
    let dictionary: [String: AnyObject] = [
      "name":usernameTextField.text!,
      "phone":photoTextField.text!,
      "roleid":"0",  // 员工
//      "email": "",
      "deptid": deptid,
      "desc":remarkTextView.text
    ]
    let userData = [dictionary]
    do {
      let data = try NSJSONSerialization.dataWithJSONObject(userData, options: NSJSONWritingOptions.PrettyPrinted)
      let strJson = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
      print(strJson)
      ZKJSHTTPSessionManager.sharedInstance().addMemberWithUserData(strJson, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        self.delegate?.RefreshTeamListTableView()
        self.navigationController?.popViewControllerAnimated(true)
        self.showHint("添加成员成功")
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      }
    } catch let error as NSError {
      print(error)
    }
  }
  
}

extension AddMemberVC: UITextViewDelegate {
  
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    var frame = view.frame
    frame.origin.y -= 100
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.frame = frame
    }
    return true
  }
  
  func textViewShouldEndEditing(textView: UITextView) -> Bool {
    var frame = view.frame
    frame.origin.y += 100
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.frame = frame
    }
    return true
  }
  
}
