//
//  AddMemberVC.swift
//  SuperService
//
//  Created by admin on 15/10/28.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

protocol RefreshTeamListVCDelegate {
  func RefreshTeamListTableView(set:[String: AnyObject],memberModel:TeamModel)
}

class AddMemberVC: UIViewController,UITextFieldDelegate {
  
  var delegate:RefreshTeamListVCDelegate?
  var roleid :String?
  @IBOutlet weak var checkoutButton: UIButton! {
    didSet {
      checkoutButton.layer.masksToBounds = true
      checkoutButton.layer.cornerRadius = 20
    }
  }
  @IBOutlet weak var departmentLabel: UILabel!
  @IBOutlet weak var managerButton: UIButton!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var photoTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  var isUncheck = false
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AddMemberVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "新建成员"
    departmentLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
    departmentLabel.layer.borderWidth = 0.5
    
    // Do any additional setup after loading the view.
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
    self.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
    //    self.hidesBottomBarWhenPushed = false
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
      "name":usernameTextField.text! ,
      "phone":photoTextField.text! ,
      "roleid":roleid! ,
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
        let dic = responseObject as! [String: AnyObject]
        let member = TeamModel(dic: dic)
            self.delegate?.RefreshTeamListTableView(dic,memberModel:member)
            self.navigationController?.popViewControllerAnimated(true)
            ZKJSTool.showMsg("添加成员成功")
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
          
      }
    } catch let error as NSError {
      print(error)
    }
  }
  
}
