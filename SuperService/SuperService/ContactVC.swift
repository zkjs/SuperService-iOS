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
    
    setupSubViews()
  }
  
  
  // MARK: - Private
  
  private func setupSubViews() {
    segmentedControl.frame.size = CGSizeMake(150.0, 30.0)
//    segmentedControl.sizeToFit()
  }
  
  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    let child1 = TeamListVC()
    let child2 = ClientListVC()
    return [child1, child2]
  }
  
}
