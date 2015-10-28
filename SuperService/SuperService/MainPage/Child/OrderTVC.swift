//
//  OrderTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class OrderTVC: UITableViewController, XLPagerTabStripChildItem {
  
  var orderArray = [OrderModel]()
  var orderPage = 1
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.header.beginRefreshing()
  }
  
  
  // MARK: - Public
  
  func loadMoreData() {
    orderPage++
    getDataWithPage(orderPage)
  }
  
  func refreshData() {
    orderArray.removeAll()
    orderPage = 1
    getDataWithPage(1)
  }
  
  
  // MARK: - Private
  
  private func setupView() {
    hidesBottomBarWhenPushed = true
    
    let nibName = UINib(nibName: OrderCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: OrderCell.reuseIdentifier())
    
    tableView.tableFooterView = UIView()
    
    tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
    tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
  }
  
  private func getDataWithPage(page: Int) {
    ZKJSHTTPSessionManager.sharedInstance().getOrderListWithPage(String(page),
      success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        if let array = responseObject as? NSArray {
          if array.count == 0 {
            self.tableView.footer.endRefreshingWithNoMoreData()
          } else {
            for dic in array {
              let order = OrderModel(dic: dic as! [String:AnyObject])
              self.orderArray.append(order)
            }
            self.tableView.reloadData()
            self.tableView.footer.endRefreshing()
          }
          self.tableView.header.endRefreshing()
        }
        
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "订单处理"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderArray.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return OrderCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(OrderCell.reuseIdentifier(), forIndexPath: indexPath) as! OrderCell
    
    if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
      cell.topLineImageView.hidden = true
    } else {
      cell.topLineImageView.hidden = false
    }
    
    let order = orderArray[indexPath.row]
    cell.setData(order)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let order = orderArray[indexPath.row]
    let storyboard = UIStoryboard(name: "OrderDetail", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("OrderDetailVC") as! OrderDetailTVC
    vc.order = order
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
