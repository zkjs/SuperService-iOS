//
//  ContactVC.swift
//  SuperService
//
//  Created by Hanton on 11/11/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ContactVC: XLSegmentedPagerTabStripViewController,UIAdaptivePresentationControllerDelegate,UIPopoverPresentationControllerDelegate {
  var guster: GusterModel? = nil
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    setupView()   
    self.containerView.scrollEnabled = false
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupRightBarButton()

  }
  
  // MARK: - Private
  
  private func setupView() {
    segmentedControl.frame.size = CGSizeMake(150.0, 30.0)
  }
  
  private func setupRightBarButton() {
    if segmentedControl.selectedSegmentIndex == 0 {//第三方控件，返回时还要去做一下判断
      if TokenPayload.sharedInstance.hasPermission(.BTNADDMEMBER) {
        // 管理员才能添加员工
        let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(ContactVC.AddMember))
        navigationItem.rightBarButtonItem = addMemberButton
      } else {
        navigationItem.rightBarButtonItem = nil
      }
    } else {//添加会员是返回在此点击进入再一次作出判断
      if TokenPayload.sharedInstance.hasPermission(.ADDMEMBER) {
        let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(ContactVC.AddVIP))
        navigationItem.rightBarButtonItem = addMemberButton
      } else {
        navigationItem.rightBarButtonItem = nil
      }
    }
  }
  
  // MARK: - Public
  
  func AddMember() {
      let vc = AddMemberVC()
      vc.pushtype = PushType.AddToteamList
      vc.delegate = self
      vc.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(vc, animated: true)
  }
  
  func AddVIP() {
    let vc = AddMemberVC()
    vc.pushtype = PushType.AddToVIPList
    vc.delegate = self
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
  
  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    if TokenPayload.sharedInstance.hasPermission(.MEMBER) {
      return [TeamListVC(),VIPListsVC()]
    }
    return [TeamListVC()]
    
  }
  
  // MARK: - XLPagerTabStripViewControllerDelegate
  
  override func pagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!, updateIndicatorFromIndex fromIndex: Int, toIndex: Int) {
    super.pagerTabStripViewController(pagerTabStripViewController, updateIndicatorFromIndex: fromIndex, toIndex: toIndex)
    setupRightBarButton()
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
