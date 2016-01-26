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
      print(responseObject)
      if let data = responseObject as? [[String: AnyObject]] {
        self.dataArray = data
        self.tableView.reloadData()
      }
      self.tableView.mj_header.endRefreshing()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        print(error)
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
    return 1
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
    cell.chatButton.addTarget(self, action: "chat:", forControlEvents: .TouchUpInside)
    cell.orderButton.addTarget(self, action: "showOrder:", forControlEvents: .TouchUpInside)
    cell.chatButton.tag = indexPath.section
    let data = dataArray[indexPath.section]
    cell.setData(data)
    return cell
  }
  
  
  
  func chat(sender:UIButton) {
    let data = dataArray[sender.tag]
    let chatterID = data["userId"] as! String
    let chatterName = data["userName"] as! String
    let vc = ChatViewController(conversationChatter: chatterID, conversationType: .eConversationTypeChat)
    let userName = AccountManager.sharedInstance().userName
      vc.title = chatterName
      vc.hidesBottomBarWhenPushed = true
      // 扩展字段
      let ext = ["toName": chatterName,
        "fromName": userName]
      vc.conversation.ext = ext
      self.navigationController?.pushViewController(vc, animated: true)
   

  }
  
  func showOrder(sender: UIButton) {
    // 正在刷新时点击无效
    if dataArray.count == 0 {
      return
    }
//    let order = dataArray[sender.tag]
//    let index = order.orderno.startIndex.advancedBy(1)
//    let type = order.orderno.substringToIndex(index)
//    if type == "H" {
//      if order.orderstatus == "待支付" || order.orderstatus == "待处理" || order.orderstatus == "待确认" || order.orderstatus == "已确认" {
//        let storyboard = UIStoryboard(name: "HotelOrderTVC", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelOrderTVC") as! HotelOrderTVC
//        vc.orderno = order.orderno
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//      } else {
//        let storyboard = UIStoryboard(name: "HotelOrderDetailTVC", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelOrderDetailTVC") as! HotelOrderDetailTVC
//        vc.orderno = order.orderno
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//      }
//      
//    }
//    if type == "O" {
//      if order.orderstatus == "待支付" || order.orderstatus == "待处理" || order.orderstatus == "待确认"{
//        let storyboard = UIStoryboard(name: "LeisureTVC", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("LeisureTVC") as! LeisureTVC
//        vc.orderno = order.orderno
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//      } else {
//        let storyboard = UIStoryboard(name: "LeisureOrderDetailTVC", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("LeisureOrderDetailTVC") as! LeisureOrderDetailTVC
//        vc.orderno = order.orderno
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//      }
//      
//    }
//    if type == "K" {
//      if order.orderstatus == "待支付" || order.orderstatus == "待处理" || order.orderstatus == "待确认"{
//        let storyboard = UIStoryboard(name: "KTVTableView", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("KTVTableView") as! KTVTableView
//        vc.orderno = order.orderno
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//      } else {
//        let storyboard = UIStoryboard(name: "KTVOrderDetailTVC", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("KTVOrderDetailTVC") as! KTVOrderDetailTVC
//        vc.orderno = order.orderno
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//      }
//    }
  }
  

  
}
