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
  
  @IBOutlet weak var checkButton: UIButton! {
    didSet {
      checkButton.layer.masksToBounds = true
      checkButton.layer.cornerRadius = 20
    }
  }
  
  @IBOutlet weak var remarkTextView: UITextView! {
    didSet {
      remarkTextView.delegate = self
      remarkTextView.layer.borderWidth = 0.5
      remarkTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
  }
  
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var positionTextField: UITextField!
  @IBOutlet weak var comapnyTextField: UITextField!
  var delegate:refreshTableViewDelegate?
  var client = ClientModel()
  @IBAction func sureAdd(sender: UIButton) {
    ZKJSHTTPSessionManager.sharedInstance().addClientWithPhone(phoneTextField.text, userid:client.userid, username: userNameTextField.text, position: positionTextField.text, company: comapnyTextField.text, other_desc: remarkTextView.text, is_bill: "1", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      let dic = responseObject as! [String: AnyObject]
      let client = ClientModel(dic: dic)
      client.username = self.userNameTextField.text
      client.phone = self.phoneTextField.text
      client.position = self.positionTextField.text
      client.company = self.comapnyTextField.text
      
      if let set = dic["set"] as? Bool {
        if set == true {
          self.delegate?.refreshTableView(dic ,clientModel: client)
          self.navigationController?.popViewControllerAnimated(true)
        } else {
          if let error = dic["err"] as? NSNumber {
            if error.integerValue == 300 {
              ZKJSTool.showMsg("该客户已经被抢, 请重新填写客户资料")
            }
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "新建会员"
    phoneTextField.text = client.phone
    userNameTextField.text = client.username
    comapnyTextField.text = client.company
    positionTextField.text = client.position
    remarkTextView.text = client.other_desc
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
