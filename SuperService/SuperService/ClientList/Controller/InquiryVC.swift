//
//  InquiryVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/2.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
import AddressBookUI
class InquiryVC: UIViewController,ABPeoplePickerNavigationControllerDelegate{
  var addressBook:ABAddressBookRef?
  var phone:String!
  var localizedPhoneLabel: String!
  @IBOutlet weak var inquiryClientButton: UIButton! {
    didSet {
      inquiryClientButton.layer.masksToBounds = true
      inquiryClientButton.layer.cornerRadius = 20
    }
  }
  @IBOutlet weak var phonrtextField: UITextField!
   @IBAction func inquiryClient(sender: AnyObject) {
    if (phonrtextField.text != nil) {
      view.endEditing(true)
      ZKJSHTTPSessionManager.sharedInstance().inquiryClientWithPhoneNumber(phonrtextField.text, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        let dic = responseObject as! [String: AnyObject]
        let client = ClientModel(dic: dic)
        let vc = AddClientVC()
        vc.client = client
        self.navigationController?.pushViewController(vc, animated: true)
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      }
      
    }
    
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("InquiryVC", owner:self, options:nil)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    let rightBarButtonItem = UIBarButtonItem(title: "通讯录", style: UIBarButtonItemStyle.Plain, target: self, action: "AccessAddressBook:")
    navigationItem.rightBarButtonItem = rightBarButtonItem
    
    // Do any additional setup after loading the view.
  }
  
  func AccessAddressBook(sender:UIBarButtonItem) {
    //弹出通讯录联系人选择界面
    let picker = ABPeoplePickerNavigationController()
    picker.peoplePickerDelegate = self
    self.presentViewController(picker, animated: true) { () -> Void in
      
    }
  }
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
    didSelectPerson person: ABRecord) {
      //获取电话
      let phoneValues:ABMutableMultiValueRef? =
      ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
      if phoneValues != nil {
        
        for i in 0 ..< ABMultiValueGetCount(phoneValues){
          
          // 获得标签名
          let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
            as CFStringRef;
          // 转为本地标签名（能看得懂的标签名，比如work、home）
          localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel).takeRetainedValue() as String
          
          let  value = ABMultiValueCopyValueAtIndex(phoneValues, i)
          self.phone = value.takeRetainedValue() as! String
          self.phonrtextField.text = self.phone
        }
      }
  }
  //取消按钮点击
  func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
    //去除地址选择界面
    peoplePicker.dismissViewControllerAnimated(true, completion: { () -> Void in
      
    })
  }
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
    shouldContinueAfterSelectingPerson person: ABRecord) -> Bool {
      return true
  }
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
    shouldContinueAfterSelectingPerson person: ABRecord, property: ABPropertyID,
    identifier: ABMultiValueIdentifier) -> Bool {
      return true
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  
}
