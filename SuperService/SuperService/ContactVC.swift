//
//  ContactVC.swift
//  SuperService
//
//  Created by Hanton on 11/11/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ContactVC: XLSegmentedPagerTabStripViewController {
  
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
      navigationItem.rightBarButtonItem = nil
    }
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
