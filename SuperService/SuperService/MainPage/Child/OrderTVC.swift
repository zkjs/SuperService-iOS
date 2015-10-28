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
    let nibName = UINib(nibName: OrderCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: OrderCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
//    let nv = UINavigationController(rootViewController: self.tableView)

    
    tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")//下拉刷新
    tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")//上拉加载
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.header.beginRefreshing()

  }
  
  //MARK: - MJRefresh Drag Download MoreData
  
  func loadMoreData() {
    self.orderPage++
    
    let salesID = AccountManager.sharedInstance().userID
    let token = AccountManager.sharedInstance().token
    let shopID = AccountManager.sharedInstance().shopID
    let page = String(orderPage)
    ZKJSHTTPSessionManager.sharedInstance().getOrderListWithSalesID(salesID, token: token, shopID: shopID, status: "1", userID: "", page: page,pagetime:"", pagedata: "10", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      
      if let array = responseObject as? NSArray {
        for dic in array {
          let order = OrderModel(dic: dic as! [String:AnyObject])
          self.orderArray.append(order)
          print(order.pay_name)
        }
        self.tableView.reloadData()
        self.tableView.footer.endRefreshing()
        
      } else {
        self.tableView.footer.endRefreshingWithNoMoreData()
      }
      
      
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  //MARK: - MJRefresh Drag Refresh Datas
  
  func refreshData() {
    self.orderPage = 1
    let salesID = AccountManager.sharedInstance().userID
    let token = AccountManager.sharedInstance().token
    let shopID = AccountManager.sharedInstance().shopID
    self.orderArray .removeAll()
    ZKJSHTTPSessionManager.sharedInstance().getOrderListWithSalesID(salesID, token: token, shopID: shopID, status: "1", userID: "", page: "1",pagetime:"", pagedata: "10", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      
      if let array = responseObject as? NSArray {
        for dic in array {
          let order = OrderModel(dic: dic as! [String:AnyObject])
          self.orderArray.append(order)
        }
        self.tableView.reloadData()
        self.tableView.header.endRefreshing()
        
      } else {
       
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
    
    let firstRow = NSIndexPath(forRow: 0, inSection: 0)
    if indexPath == firstRow {
      cell.topLineImageView.hidden = true
    } else {
      cell.topLineImageView.hidden = false
    }
    let order = orderArray[indexPath.row]
    cell.setData(order)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let order = orderArray[indexPath.row]
    self.hidesBottomBarWhenPushed = true
    let storyboard = UIStoryboard(name: "OrderDetail", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("OrderDetailVC") as! OrderDetailTVC
    navigationController?.pushViewController(vc, animated: true)
    vc.DetailOrder = order
    
  }
}
