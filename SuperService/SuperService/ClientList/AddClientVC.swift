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

class AddClientVC: UIViewController {
  
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var positionTextField: UITextField!
  @IBOutlet weak var comapnyTextField: UITextField!
  var delegate:refreshTableViewDelegate?
  
  @IBAction func sureAdd(sender: UIButton) {
   
    let userID = AccountManager.sharedInstance().userID
    let shopID = AccountManager.sharedInstance().shopID
    let token = AccountManager.sharedInstance().token
    ZKJSHTTPSessionManager.sharedInstance().addClientWithUserID(userID, token: token, shopID: shopID, phone: phoneTextField.text, username: userNameTextField.text, position: positionTextField.text, company: comapnyTextField.text, other_desc: remarkTextView.text, is_bill: "1", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
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
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新建会员"
        // Do any additional setup after loading the view.
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
