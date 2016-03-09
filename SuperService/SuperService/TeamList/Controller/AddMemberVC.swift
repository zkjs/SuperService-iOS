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

@available(iOS 9.0, *)
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
    if photoTextField.text == ""  || usernameTextField.text == "" {
      self.showHint("请填写完整信息")
      return
    }
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
      func analyzeContactProperty(contact:ABRecordRef, property:ABPropertyID, keySuffix:String) -> [String:String]? {
        let propertyValues:ABMultiValueRef? = ABRecordCopyValue(contact, property)?.takeRetainedValue()
        if propertyValues != nil {
          //var values:NSMutableArray = NSMutableArray()
          var valueDictionary:Dictionary = [String:String]()
          for i in 0 ..< ABMultiValueGetCount(propertyValues) {
            var label:String = ABMultiValueCopyLabelAtIndex(propertyValues, i).takeRetainedValue() as String
            label += keySuffix
            let value = ABMultiValueCopyValueAtIndex(propertyValues, i)
            switch property {
            case kABPersonSocialProfileProperty :
              let snsNSDict:NSMutableDictionary = value.takeRetainedValue() as! NSMutableDictionary
              valueDictionary[label+"_Username"] = snsNSDict.valueForKey(kABPersonSocialProfileUsernameKey as String) as? String ?? ""
              valueDictionary[label+"_URL"] = snsNSDict.valueForKey(kABPersonSocialProfileURLKey as String) as? String ?? ""
              valueDictionary[label+"_Serves"] = snsNSDict.valueForKey(kABPersonSocialProfileServiceKey as String) as? String ?? ""
              // IM
            case kABPersonInstantMessageProperty :
              let imNSDict:NSMutableDictionary = value.takeRetainedValue() as! NSMutableDictionary
              valueDictionary[label+"_Serves"] = imNSDict.valueForKey(kABPersonInstantMessageServiceKey as String) as? String ?? ""
              valueDictionary[label+"_Username"] = imNSDict.valueForKey(kABPersonInstantMessageUsernameKey as String) as? String ?? ""
              // Date
            case kABPersonDateProperty :
              valueDictionary[label] = (value.takeRetainedValue() as? NSDate)?.description
            default :
              valueDictionary[label] = value.takeRetainedValue() as? String ?? ""
            }
          }
          return valueDictionary
        }else{
          return nil
        }
      }
      
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
        for (key, value) in analyzeContactProperty(contact, property: kABPersonPhoneProperty,keySuffix: "Phone") ?? ["":""] {
          currentContact[key] = value
          phone = value
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

@available(iOS 9.0, *)
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
