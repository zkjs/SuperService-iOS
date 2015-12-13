//
//  CodeVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class CodeVC: XLSegmentedPagerTabStripViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubViews()
  }
  
  
  // MARK: - Private
  
  private func setupSubViews() {
    segmentedControl.frame.size = CGSizeMake(150.0, 30.0)
    //    segmentedControl.sizeToFit()
  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    self.hidesBottomBarWhenPushed = false
  }
  
  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    let child1 = UnbindCodeTVC()
    let child2 = BindCodeTVC()
    return [child1, child2]
  }
  
}
