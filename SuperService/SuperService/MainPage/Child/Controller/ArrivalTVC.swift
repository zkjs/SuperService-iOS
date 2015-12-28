//
//  ArrivalTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalTVC: UITableViewController {
  
  lazy var dataArray = [[String: AnyObject]]()
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("ArrivalTVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    // 因为程序退到后台再回到前台时不会触发viewWillAppear，所以需要此方法刷新列表
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "refresh",
      name: kRefreshArrivalTVCNotification,
      object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    tabBarItem.badgeValue = nil
    NSUserDefaults.standardUserDefaults().setObject(NSNumber(integer: 0), forKey: kArrivalInfoBadge)
    loadData()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  // MARK: - Public
  
  func refresh() {
    // 只有当当前VC可见时才刷新数据
    if isViewLoaded() && (view.window != nil) {
      tabBarItem.badgeValue = nil
      loadData()
    }
  }
  
  func loadData() {
    ZKJSJavaHTTPSessionManager.sharedInstance().getArrivalInfoWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let data = responseObject as? [[String: AnyObject]] {
        self.dataArray = data
        self.tableView.reloadData()
      }
      print(responseObject)
      self.tableView.mj_header.endRefreshing()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        self.tableView.mj_header.endRefreshing()
    }
  }
  
  func loadMoreData() {
//    if let timestamp = dataArray.last?.timestamp,
//      let moreDataArray = Persistence.sharedInstance().fetchClientArrivalInfoArrayBeforeTimestamp(timestamp) where moreDataArray.count > 0 {
//        dataArray += moreDataArray
//        tableView.reloadData()
//    }
//    tableView.mj_footer.endRefreshing()
  }
  
  
  // MARK: - Private
  
  func setupView() {
    title = "到店通知"
    let nibName = UINib(nibName: ArrivalCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: ArrivalCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refresh")  // 下拉刷新
//    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
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
