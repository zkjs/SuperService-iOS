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
    
//    // 解散会话
//    // MsgShopDisbandSession
//    let timestamp = Int64(NSDate().timeIntervalSince1970)
//    let dictionary: [String: AnyObject] = [
//      "type": 220,
//      "timestamp": NSNumber(longLong: timestamp),
//      "shopid": "120",
//      "sessionid": "5639a18dc1905_120_DefaultChatRuleType",
//      "fromid": "5629a1adf119f"
//    ]
//    ZKJSTCPSessionManager.sharedInstance().sendPacketFromDictionary(dictionary)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    addRightBarButton()
    tableView.header.beginRefreshing()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    removeRightBarButton()
  }
  
  
  // MARK: - Public
  
  func loadMoreData() {
    orderPage++
    getDataWithPage(orderPage)
  }
  
  func refreshData() {
    orderArray = [OrderModel]()
    orderPage = 1
    getDataWithPage(1)
  }
  
  
  // MARK: - Private
  
  private func addRightBarButton() {
    let addOrderButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"),
      style: .Plain,
      target: self,
      action: "addOrder")
    let mainTBC = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTBC
    let baseNC = mainTBC.selectedViewController as! BaseNavigationController
    baseNC.topViewController?.navigationItem.rightBarButtonItem = addOrderButton
  }
  
  private func removeRightBarButton() {
    let mainTBC = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainTBC
    let baseNC = mainTBC.selectedViewController as! BaseNavigationController
    baseNC.topViewController?.navigationItem.rightBarButtonItem = nil
  }
  
  private func setupView() {
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
    cell.orderButton.tag = indexPath.row
    cell.orderButton.addTarget(self, action: "showOrder:", forControlEvents: .TouchUpInside)
    return cell
  }
  
  
  // MARK: - Button Action
  
  func addOrder() {
    let storyboard = UIStoryboard(name: "OrderDetail", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("OrderDetailVC") as! OrderDetailTVC
    vc.type = .Add
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func showOrder(sender: UIButton) {
    // 正在刷新时点击无效
    if orderArray.count == 0 {
      return
    }
    
    let order = orderArray[sender.tag]
    let storyboard = UIStoryboard(name: "OrderDetail", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("OrderDetailVC") as! OrderDetailTVC
    vc.type = .Update
    vc.reservationNO = order.reservation_no
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
