//
//  ContactVC.swift
//  SuperService
//
//  Created by Hanton on 11/11/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ContactVC: XLSegmentedPagerTabStripViewController {
  var guster: GusterModel? = nil
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    
    setupView()
    setupRightBarButton()
    
    let bGotoContactList = NSUserDefaults.standardUserDefaults().boolForKey(kGotoContactList)
    if bGotoContactList == true {
      segmentedControl.selectedSegmentIndex = 1
      moveToViewControllerAtIndex(1, animated: false)
      let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "Addguest")
      navigationItem.rightBarButtonItem = addMemberButton
      NSUserDefaults.standardUserDefaults().setBool(false, forKey: kGotoContactList)
    }
  }
  
  // MARK: - Private
  
  private func setupView() {
    segmentedControl.frame.size = CGSizeMake(150.0, 30.0)
  }
  
  private func setupRightBarButton() {
    let isAdmin = TokenPayload.sharedInstance.isAdmin
    if isAdmin {
      // 管理员才能添加员工
      let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "AddMember")
      navigationItem.rightBarButtonItem = addMemberButton
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  // MARK: - Public
  
  func AddMember() {
    if #available(iOS 9.0, *) {
      let vc = AddMemberVC()
      vc.delegate = self
      vc.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(vc, animated: true)
    } else {
        // Fallback on earlier versions
    }
    
  }
  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    let child1 = TeamListVC()
//    let child2 = ClientListVC()
    return [child1]
  }
  
  // MARK: - XLPagerTabStripViewControllerDelegate
  
  override func pagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!, updateIndicatorFromIndex fromIndex: Int, toIndex: Int) {
    super.pagerTabStripViewController(pagerTabStripViewController, updateIndicatorFromIndex: fromIndex, toIndex: toIndex)
    
    if toIndex == 0 {
      setupRightBarButton()
    } else {
      let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "Addguest")
      navigationItem.rightBarButtonItem = addMemberButton
    }
  }
  
  func Addguest() {
    let alertController = UIAlertController(title: "添加客户", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let checkAction = UIAlertAction(title: "查询", style: .Default) { (_) in
      let phoneTextField = alertController.textFields![0] as UITextField
      if phoneTextField.text!.characters.count > 11 {
        return
      }
      guard let phone = phoneTextField.text else { return }
      phoneTextField.resignFirstResponder()
      self.showHUDInView(self.view, withLoading: "正在查找...")
        ZKJSHTTPSessionManager.sharedInstance().checkGusterWithPhone(phone, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          print(responseObject)
          if let data = responseObject as? [String: AnyObject] {
            if let set = data["is_bd"] as? Bool {
              if set == false {
                self.hideHUD()
                self.showHint("该客人未激活,请使用邀请码绑定")
                self.view.endEditing(true)
                return
              }
            }
            if let set = data["set"] as? NSNumber {
              if set.boolValue == false {
                self.hideHUD()
                self.showHint("此客人不存在")
              } else {
                self.guster = GusterModel(dic: data)
                if let salesid = self.guster?.salesid {
                  self.hideHUD()
                  if salesid == "" {
                    let vc = AddSalesVC()
                    vc.guster = self.guster
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                  } else {
                    self.showHint("客人已被销售添加")
                  }
                }
              }
            }
          }
          }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            print(error)
            self.hideHUD()
        }
      }
    checkAction.enabled = false
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (_) in
      self.view.endEditing(true)
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) in
      textField.placeholder = "请输入客户的手机号码"
      textField.keyboardType = UIKeyboardType.NumberPad
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
        checkAction.enabled = (textField.text != "")
      }
    }
    alertController.addAction(checkAction)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
}

// RefreshTeamListVCDelegate

extension ContactVC: RefreshTeamListVCDelegate {
  
  func RefreshTeamListTableView() {
    if let vc = pagerTabStripChildViewControllers[0] as? TeamListVC {
      vc.refresh()
    }
  }
  
}

extension ContactVC: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if (range.location + string.characters.count <= 11) {
      return true
    } else {
      return false
    }
  }
}
