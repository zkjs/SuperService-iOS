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
  }
  
  // MARK: - Private
  
  private func setupView() {
    segmentedControl.frame.size = CGSizeMake(150.0, 30.0)
  }
  
  private func setupRightBarButton() {
    let isAdmin = AccountManager.sharedInstance().isAdmin()
    if isAdmin {
      // 管理员才能添加员工
      let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "AddMember")
      navigationItem.rightBarButtonItem = addMemberButton
    }
  }
  
  // MARK: - Public
  
  func AddMember() {
    let vc = AddMemberVC()
    vc.delegate = self
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    let child1 = TeamListVC()
    let child2 = ClientListVC()
    return [child1, child2]
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
      guard let phone = phoneTextField.text else { return }
      phoneTextField.resignFirstResponder()
      self.showHUDInView(self.view, withLoading: "正在查找...")
        ZKJSHTTPSessionManager.sharedInstance().checkGusterWithPhone(phone, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          print(responseObject)
          if let data = responseObject as? [String: AnyObject] {
            if let set = data["is_bd"] as? Bool {
              if set == false {
                self.showHint("该客人未激活,请使用邀请码绑定")
                self.view.endEditing(true)
                self.hideHUD()
                return
              }
            }
            if let set = data["set"] as? NSNumber {
              if set.boolValue == false {
               self.showHint("此客人不存在")
              } else {
                self.guster = GusterModel(dic: data)
                if let salesid = self.guster?.salesid {
                  if salesid == "" {
                    let vc = AddSalesVC()
                    vc.guster = self.guster
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                  } else {
                    self.hideHUD()
                    self.showHint("此客人已经被其他销售员添加过")
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
      textField.placeholder = "请输入销售人员的手机号码"
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
