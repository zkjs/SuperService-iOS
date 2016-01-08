//
//  OrderTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class OrderTVC: UITableViewController {
  
  lazy var orderArray = [OrderListModel]()
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
//    addRightBarButton()
  }
  
  private func getDataWithPage(page: Int) {
    
    ZKJSJavaHTTPSessionManager.sharedInstance().getOrderListWithPage(String(page),
      success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        if let array = responseObject as? NSArray {
          if array.count == 0 {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
            self.tableView.mj_header.endRefreshing()
          } else {
            if page == 1 {
              self.orderArray.removeAll()
            }
            for dic in array {
              let order = OrderListModel(dic: dic as! [String:AnyObject])
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
    let storyboard = UIStoryboard(name: "HotelOrderTVC", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("HotelOrderTVC") as! HotelOrderTVC
    vc.type = .Add
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func showOrder(sender: UIButton) {
    // 正在刷新时点击无效
    if orderArray.count == 0 {
      return
    }
    let order = orderArray[sender.tag]
    let index = order.orderno.startIndex.advancedBy(1)
    let type = order.orderno.substringToIndex(index)
    if type == "H" {
      if order.orderstatus == "待支付" || order.orderstatus == "待确认" {
        let storyboard = UIStoryboard(name: "HotelOrderTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelOrderTVC") as! HotelOrderTVC
        vc.orderno = order.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        let storyboard = UIStoryboard(name: "HotelOrderDetailTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelOrderDetailTVC") as! HotelOrderDetailTVC
        vc.orderno = order.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }
      
    }
    if type == "O" {
      if order.orderstatus == "待支付" || order.orderstatus == "待确认" {
        let storyboard = UIStoryboard(name: "LeisureTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LeisureTVC") as! LeisureTVC
        vc.orderno = order.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        let storyboard = UIStoryboard(name: "LeisureOrderDetailTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LeisureOrderDetailTVC") as! LeisureOrderDetailTVC
        vc.orderno = order.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }
     
    }
    if type == "K" {
      if order.orderstatus == "待支付" || order.orderstatus == "待确认" {
        let storyboard = UIStoryboard(name: "KTVTableView", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("KTVTableView") as! KTVTableView
        vc.orderno = order.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        let storyboard = UIStoryboard(name: "KTVOrderDetailTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("KTVOrderDetailTVC") as! KTVOrderDetailTVC
        vc.orderno = order.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }
      
    }
  
        }
  
}
