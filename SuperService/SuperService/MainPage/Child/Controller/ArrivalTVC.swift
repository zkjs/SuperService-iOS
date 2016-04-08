//
//  ArrivalTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalTVC: UITableViewController {
  
  lazy var dataArray = [ArrivateModel]()
  var orderno: String!
  var orderstatus:String!
  
  var ordernoArray = [String]()
  var orderstatusArray = [String]()
  var page:Int = 0
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
    page = 0
    loadData(page)
    if let roles = TokenPayload.sharedInstance.roles where roles.contains("POS") {
      addBarButtons() 
    }
              
  }
  

  private func addBarButtons() {
    let buttonCounter = UIBarButtonItem(image: UIImage(named: "ic_till"),
      style: .Plain,
      target: self,
      action: "gotoCkeckoutCounter")
    navigationItem.rightBarButtonItem = buttonCounter
  }

  // MARK: - Button Action

  func gotoCkeckoutCounter() {
    let storyboard = UIStoryboard(name: "CheckoutCounter", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("CheckoutCounterVC") as! CheckoutCounterVC
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func loadMoreData() {
    ++page
    loadData(page)
  }
  
  func refreshData() {
    page = 0
    loadData(page)
  }
  
  
  // MARK: - Public
  
  func refresh() {
    // 只有当当前VC可见时才刷新数据
    if isViewLoaded() && (view.window != nil) {
      tabBarItem.badgeValue = nil
    }
  }
  
  func loadData(page:Int) {
    print(AccountInfoManager.sharedInstance.beaconLocationIDs)
    HttpService.sharedInstance.arrivateList(page) { (arrivateArr, error) -> () in
      if let _  = error {
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      } else {
        if page == 0 {
          self.dataArray.removeAll()
        }
        if let users = arrivateArr where users.count > 0 {
          self.dataArray += users
          self.tableView?.reloadData()
        }
        if arrivateArr?.count < HttpService.DefaultPageSize {
          self.tableView.mj_footer.hidden = true
        }
    }
    self.tableView.mj_header.endRefreshing()
    self.tableView.mj_footer.endRefreshing()
      
   }
  }
  

  // MARK: - Private
  
  func setupView() {
    title = "到店通知"
    let nibName = UINib(nibName: ArrivalCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: ArrivalCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
    tableView.mj_header.beginRefreshing()
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
//    cell.chatButton.addTarget(self, action: "chat:", forControlEvents: .TouchUpInside)
    cell.orderButton.addTarget(self, action: "showOrder:", forControlEvents: .TouchUpInside)
//    cell.chatButton.tag = indexPath.section
    let data = dataArray[indexPath.section]
    cell.setData(data)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! ArrivalCell
    cell.orderButton.tag = indexPath.section
    self.showOrder(cell.orderButton)
  }
  
  
  
  func chat(sender:UIButton) {
    let data = dataArray[sender.tag]
    guard let chatterID = data.userid, let chatterName = data.username else { return }
    let vc = ChatViewController(conversationChatter: chatterID, conversationType: .eConversationTypeChat)
    let userName = AccountInfoManager.sharedInstance.userName
      vc.title = chatterName
      vc.hidesBottomBarWhenPushed = true
      // 扩展字段
      let ext = ["toName": chatterName,
    "fromName": userName]
      vc.conversation.ext = ext
      vc.title = chatterName
      self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func showOrder(sender: UIButton) {
    // 正在刷新时点击无效
    if dataArray.count == 0 {
      return
    }
    let order = self.dataArray[sender.tag]
    guard let orderno = order.orderno else {return}
    let index = orderno.startIndex.advancedBy(1)
    let type = orderno.substringToIndex(index)
    if type == "H" {
        let storyboard = UIStoryboard(name: "HotelOrderDetailTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelOrderDetailTVC") as! HotelOrderDetailTVC
        vc.orderno = orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    if type == "O" {
      if self.orderstatus == "待支付" || self.orderstatus == "待处理" || self.orderstatus == "待确认"{
        let storyboard = UIStoryboard(name: "LeisureTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LeisureTVC") as! LeisureTVC
        vc.orderno = self.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        let storyboard = UIStoryboard(name: "LeisureOrderDetailTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LeisureOrderDetailTVC") as! LeisureOrderDetailTVC
        vc.orderno = self.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }
      
    }
    if type == "K" {
      if self.orderstatus == "待支付" || self.orderstatus == "待处理" || self.orderstatus == "待确认"{
        let storyboard = UIStoryboard(name: "KTVTableView", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("KTVTableView") as! KTVTableView
        vc.orderno = self.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      } else {
        let storyboard = UIStoryboard(name: "KTVOrderDetailTVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("KTVOrderDetailTVC") as! KTVOrderDetailTVC
        vc.orderno = self.orderno
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
  

  
}
