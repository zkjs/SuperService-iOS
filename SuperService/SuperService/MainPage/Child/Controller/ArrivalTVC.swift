//
//  ArrivalTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalTVC: UITableViewController, XLPagerTabStripChildItem {
  
  var dataArray = [ClientArrivalInfo]()
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("ArrivalTVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "refresh",
      name: kRefreshArrivalTVCNotification,
      object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    refresh()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  // MARK: - Public
  
  func refresh() {
    dataArray = [ClientArrivalInfo]()
    if let data = Persistence.sharedInstance().fetchClientArrivalInfoArrayBeforeTimestamp(NSDate()) where data.count > 0 {
      dataArray = data
      tableView.reloadData()
    }
    tableView.header.endRefreshing()
  }
  
  func loadMoreData() {
    if let timestamp = dataArray.last?.timestamp,
      let moreDataArray = Persistence.sharedInstance().fetchClientArrivalInfoArrayBeforeTimestamp(timestamp) where moreDataArray.count > 0 {
        dataArray += moreDataArray
        tableView.reloadData()
    }
    tableView.footer.endRefreshing()
  }
  
  
  // MARK: - Private
  
  func setupView() {
    let nibName = UINib(nibName: ArrivalCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: ArrivalCell.reuseIdentifier())
    
    tableView.tableFooterView = UIView()
    
    tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")  // 下拉刷新
    tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
  }
  
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "到店通知"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ArrivalCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(ArrivalCell.reuseIdentifier(), forIndexPath: indexPath) as! ArrivalCell

    let firstRow = NSIndexPath(forRow: 0, inSection: 0)
    if indexPath == firstRow {
      cell.topLineImageView.hidden = true
    } else {
      cell.topLineImageView.hidden = false
    }
    
    let data = dataArray[indexPath.row]
    cell.setData(data)
    
    return cell
  }
  
}
