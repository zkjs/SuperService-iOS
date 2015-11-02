//
//  AddClientVC.swift
//  SuperService
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

protocol refreshTableViewDelegate{
  func refreshTableView(set:[String: AnyObject],clientModel:ClientModel)
}

class AddClientVC: UIViewController,UITextViewDelegate{
  
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var positionTextField: UITextField!
  @IBOutlet weak var comapnyTextField: UITextField!
  var delegate:refreshTableViewDelegate?
  
  @IBAction func sureAdd(sender: UIButton) {
    //根据角色的区分来判断登陆的是服务员还是管理员，调用不同的接口
    let roleID = AccountManager.sharedInstance().roleID
    if roleID == "1" {
      ZKJSHTTPSessionManager.sharedInstance().addClientWithPhone(phoneTextField.text, username: userNameTextField.text, position: positionTextField.text, company: comapnyTextField.text, other_desc: remarkTextView.text, is_bill: "1", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        let dic = responseObject as! [String: AnyObject]
        let client = ClientModel(dic: dic)
        client.username = self.userNameTextField.text
        client.phone = self.phoneTextField.text
        client.position = self.positionTextField.text
        client.company = self.comapnyTextField.text
        
        if let set = dic["set"] as? Bool {
          if set == true {
            self.delegate?.refreshTableView(dic ,clientModel: client)
          } else {
            
          }
        }
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      }

    } else {
      ZKJSHTTPSessionManager.sharedInstance().waiterAddClientWithPhone(phoneTextField.text, tag: remarkTextView.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        let dic = responseObject as! [String: AnyObject]
        let client = ClientModel(dic: dic)
        client.username = self.userNameTextField.text
        client.phone = self.phoneTextField.text
        if let set = dic["set"] as? Bool {
          if set == true {
            self.delegate?.refreshTableView(dic ,clientModel: client)
          } else {
            
          }
        }
        }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "新建会员"
    //print(self.view.center.x,self.view.center.y)
    remarkTextView.delegate = self
    remarkTextView.layer.borderWidth = 0.5
    remarkTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK - Text View Delegate
  
  func textViewDidBeginEditing(textView: UITextView) {
    UIView.animateWithDuration(0.5) { () -> Void in
      self.view.bounds.origin = CGPoint(x: 0, y: 140)
    }
    
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    UIView.animateWithDuration(0.5) { () -> Void in
      self.view.bounds.origin = CGPoint(x: 0, y: 0)
    }
    
  }
  
}
