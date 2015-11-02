//
//  MainVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MainPageVC: XLSegmentedPagerTabStripViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubViews()
  }
  
  
  // MARK: - Private
  
  private func setupSubViews() {
    segmentedControl.sizeToFit()
  }

  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    let child1 = ArrivalTVC()
    let child2 = OrderTVC()
    return [child1, child2]
  }
  
}
