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

class AddMemberVC: UIViewController,UITextFieldDelegate {
  
  var delegate: RefreshTeamListVCDelegate?
  var roleid = "0"  // 初始化值为员工
  var isUncheck = false
  
  @IBOutlet weak var departmentLabel: UILabel!
  @IBOutlet weak var managerButton: UIButton!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var photoTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AddMemberVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "新建成员"
    departmentLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
    departmentLabel.layer.borderWidth = 0.5

  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func choiceDepartmentButton(sender: AnyObject) {
    let vc = MemberListVC()
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func IsManager(sender: AnyObject) {
    isUncheck = !isUncheck
    if isUncheck {
      managerButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
      roleid = "1"
    }
    else {
      managerButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
      roleid = "0"
    }
  }
  
  @IBAction func sureButton(sender: AnyObject) {
    let dictionary: [String: AnyObject] = [
      "name":usernameTextField.text!,
      "phone":photoTextField.text!,
      "roleid":roleid,
      "email": "",
      "deptid": "0",
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
