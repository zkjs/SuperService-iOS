//
//  TaskContainerVC.swift
//  SuperService
//
//  Created by Qin Yejun on 6/25/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

class TaskContainerVC: XLSegmentedPagerTabStripViewController,UIAdaptivePresentationControllerDelegate,UIPopoverPresentationControllerDelegate {
  var guster: GusterModel? = nil
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    setupView()
    self.containerView.scrollEnabled = false
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  // MARK: - Private
  
  private func setupView() {
    segmentedControl.frame.size = CGSizeMake(150.0, 30.0)
  }
  
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
  
  
  // MARK: - XLPagerTabStripViewControllerDataSource
  
  override func childViewControllersForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> [AnyObject]! {
    return [CallInfoVC(),TaskListVC()]
  }
  
  // MARK: - XLPagerTabStripViewControllerDelegate
  
  override func pagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!, updateIndicatorFromIndex fromIndex: Int, toIndex: Int) {
    super.pagerTabStripViewController(pagerTabStripViewController, updateIndicatorFromIndex: fromIndex, toIndex: toIndex)
  }
  
}
