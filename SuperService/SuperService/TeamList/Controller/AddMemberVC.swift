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
  var massDicArray = [[String:String]]()//批量选择联系人的手机和名字的数组集合

  
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var photoTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AddMemberVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "新建成员"
  
    
    remarkTextView.layer.borderColor = UIColor(white: 204.0/255.0, alpha: 1.0).CGColor
    remarkTextView.layer.borderWidth = 0.5
    remarkTextView.layer.masksToBounds = true
    remarkTextView.layer.cornerRadius = 3
    
    let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: "Addteams:")
    navigationItem.rightBarButtonItem = addMemberButton
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
  }
  
  @IBAction func choiceDepartmentButton(sender: AnyObject) {
    let vc = MemberListVC()
    view.endEditing(true)
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func sureButton(sender: AnyObject) {
    let dictionary: [String: String] = [
      "username":usernameTextField.text!,
      "phone":photoTextField.text!,
    ]
    if photoTextField.text == ""  || usernameTextField.text == "" {
      self.showHint("请填写完整信息")
      return
    }
    massDicArray.append(dictionary)
    let userData = ["users":massDicArray]
    HttpService.sharedInstance.AddMember(userData) { (json, error) -> () in
      if let _ = error {
        self.showHint("添加失败")
      } else {
        if let json = json {
          if let res = json["res"].int {
            if res == 0 {
              self.showHint("添加成功")
              self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
              self.showHint("\(json["resDesc"].string)")
            }
          }
        }
      }
    }
//    do {
//      let data = try NSJSONSerialization.dataWithJSONObject(userData, options: NSJSONWritingOptions.PrettyPrinted)
//      let strJson = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
//      print(strJson)
//      ZKJSHTTPSessionManager.sharedInstance().addMemberWithUserData(strJson, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
//        self.delegate?.RefreshTeamListTableView()
//        self.navigationController?.popViewControllerAnimated(true)
//        self.showHint("添加成员成功")
//        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
//          
//      }
//    } catch let error as NSError {
//      print(error)
//    }
    

  }
  
  func Addteams(sender:UIBarButtonItem) {
    getSysContacts()
  }
  
  @IBAction func addFromMailList(sender: AnyObject) {
    getSysContacts()
  }
  
  func getSysContacts() -> [[String:String]] {
    var error:Unmanaged<CFError>?
    var addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
    
    let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
    
    if sysAddressBookStatus == .Denied || sysAddressBookStatus == .NotDetermined {
      // Need to ask for authorization
      var authorizedSingal:dispatch_semaphore_t = dispatch_semaphore_create(0)
      var askAuthorization:ABAddressBookRequestAccessCompletionHandler = { success, error in
        if success {
          ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
          dispatch_semaphore_signal(authorizedSingal)
        }
      }
      ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
      dispatch_semaphore_wait(authorizedSingal, DISPATCH_TIME_FOREVER)
    }
    
    
  func analyzeSysContacts(sysContacts:NSArray) -> [[String:String]] {
      var allContacts:Array = [[String:String]]()
      for contact in sysContacts {
        var currentContact:Dictionary = [String:String]()
        // 姓、姓氏拼音
        currentContact["FirstName"] = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
        // 名、名字拼音
        currentContact["LastName"] = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
        // 姓名整理
        currentContact["fullName"] =    currentContact["LastName"]! + currentContact["FirstName"]!
        // 电话
        var phone = String()
        let propertyValues:ABMultiValueRef? = ABRecordCopyValue(contact, kABPersonPhoneProperty)?.takeRetainedValue()
        if propertyValues != nil {
        for i in 0 ..< ABMultiValueGetCount(propertyValues){
            let value = ABMultiValueCopyValueAtIndex(propertyValues, i)
            phone = value.takeRetainedValue() as? String ?? ""
            print("\(phone)")
          }
        }
        let dic: [String : String] = ["username":currentContact["fullName"]!,"phone":phone]
        allContacts.append(dic)
        print(dic)
      }
      let vc = MassAddVC()
      vc.ContactsArray = allContacts
      self.navigationController?.pushViewController(vc, animated: true)
      return allContacts
    }
    return analyzeSysContacts( ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray )
  }
  
}

extension AddMemberVC: UITextViewDelegate {
  
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    if textView.text == "如有备注，在此说明" {
      textView.text = ""
    }
    var frame = view.frame
    frame.origin.y -= 100
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.frame = frame
    }
    return true
  }
  
  func textViewShouldEndEditing(textView: UITextView) -> Bool {
    if textView.text == "" {
      textView.text = "如有备注，在此说明"
    }
    var frame = view.frame
    frame.origin.y += 100
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.frame = frame
    }
    return true
  }
  
}
