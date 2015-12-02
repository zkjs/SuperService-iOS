//
//  OrderTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class OrderTVC: UITableViewController {
  
  lazy var orderArray = [OrderModel]()
  var orderPage = 1
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("OrderTVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.mj_header.beginRefreshing()
  }
  
  
  // MARK: - Public
  
  func loadMoreData() {
    orderPage++
    getDataWithPage(orderPage)
  }
  
  func refreshData() {
    orderPage = 1
    getDataWithPage(1)
    
  }
  
  
  // MARK: - Private
  
  private func addRightBarButton() {
    let addOrderButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"),
      style: .Plain,
      target: self,
      action: "addOrder")
    navigationItem.rightBarButtonItem = addOrderButton
  }
  
  private func setupView() {
    title = "订单"
    
    let nibName = UINib(nibName: OrderCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: OrderCell.reuseIdentifier())
    
    tableView.tableFooterView = UIView()
    
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
    
    addRightBarButton()
  }
  
  private func getDataWithPage(page: Int) {
    
    ZKJSHTTPSessionManager.sharedInstance().getOrderListWithPage(String(page),
      success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        
        if let array = responseObject as? NSArray {
          if array.count == 0 {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
          } else {
            if page == 1 {
              self.orderArray.removeAll()
            }
            for dic in array {
              let order = OrderModel(dic: dic as! [String:AnyObject])
              self.orderArray.append(order)
            }
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
          }
          self.tableView.mj_header.endRefreshing()
         
        }
        
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
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
