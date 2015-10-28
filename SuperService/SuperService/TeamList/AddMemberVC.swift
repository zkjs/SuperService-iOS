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
  @IBOutlet weak var departmentLabel: UILabel!
  @IBOutlet weak var managerButton: UIButton!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var photoTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  var isUncheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "新建成员"
     departmentLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
      departmentLabel.layer.borderWidth = 0.5

        // Do any additional setup after loading the view.
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
      
    }
    else {
      managerButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
    }
  }
  @IBAction func sureButton(sender: AnyObject) {
    
      let userID = AccountManager.sharedInstance().userID
      let token = AccountManager.sharedInstance().token
      let shopID = AccountManager.sharedInstance().shopID
      ZKJSHTTPSessionManager.sharedInstance().addMemberWithUserID(userID, token: token, shopID: shopID, phone: photoTextField.text, name: usernameTextField.text, roleid: "1", email: "", dept: departmentLabel.text, desc: remarkTextView.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        var dic = responseObject as! [String: AnyObject]
        let member = TeamModel(dic: dic)
        if let set = dic["set"] as? Bool {
          if set == true {
            self.delegate?.RefreshTeamListTableView(dic,memberModel:member)
            ZKJSTool.showMsg("添加成员成功")
            
          }else {
            ZKJSTool.showMsg("请填写完整信息")
          }
        }
        
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          

    }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
