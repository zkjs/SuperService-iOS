//
//  ArrivalTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit
import CoreBluetooth
class ArrivalTVC: UITableViewController,GotoLabelVCDelegate {
  
  lazy var dataArray = [ArrivateModel]()
  var orderno: String!
  var orderstatus:String!
  
  var ordernoArray = [String]()
  var orderstatusArray = [String]()
  var page:Int = 0
  var isLoading:Bool = false
  var bluetoothManager: CBCentralManager!
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("ArrivalTVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
     setupView()
    // 因为程序退到后台再回到前台时不会触发viewWillAppear，所以需要此方法刷新列表
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(refresh),
      name: kRefreshArrivalTVCNotification,
      object: nil)
    
    bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    BeaconMonitor.sharedInstance.startMonitoring()
    LocationStateObserver.sharedInstance.start()
    
  }
  
  override func viewWillAppear(animated: Bool) {

    super.viewWillAppear(animated)
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    tabBarItem.badgeValue = nil
    NSUserDefaults.standardUserDefaults().setObject(NSNumber(integer: 0), forKey: kArrivalInfoBadge)
    if let arr = StorageManager.sharedInstance().nearBeaconLocid()
      where arr.count  > 0 && TokenPayload.sharedInstance.hasPermission(.CASHREGISTER) {
      addBarButtons() 
    } else {
      navigationItem.rightBarButtonItem = nil
    }
    tableView.mj_header.beginRefreshing()
   
              
  }
  
  private func addBarButtons() {
    let buttonCounter = UIBarButtonItem(image: UIImage(named: "ic_till"),
      style: .Plain,
      target: self,
      action: #selector(gotoCheckoutCounter))
    navigationItem.rightBarButtonItem = buttonCounter
  }

  // MARK: - Button Action

  func gotoCheckoutCounter() {
    //根据储存的locid查找beacon，再去对比扫描得到的beacon信息去反查找相应的locid，没有则不做跳转
    if bluetoothManager.state == .PoweredOff {
      let alertController = UIAlertController(title: "您没有打开蓝牙,暂时无法收款", message: "", preferredStyle: .Alert)
      let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
      }
      alertController.addAction(checkAction)
      self.presentViewController(alertController, animated: true, completion: nil)
      return
    }
    var userlocids:Set<String> = []
    let blueBeacon = BeaconMonitor.sharedInstance.beaconInfoCache.keys
    if let storeBeacons = StorageManager.sharedInstance().getBeaconsFromLoicd()?.keys ,
      let dic = StorageManager.sharedInstance().getBeaconsFromLoicd(){
      for s in storeBeacons {
        if blueBeacon.contains(s) {
           guard let value = dic[s] else {return}
           userlocids.insert(value)
           print(value)
         }
       }
    }
    
    if userlocids.count == 0 {
      let alertController = UIAlertController(title: "您不在收款区域,暂时无法收款", message: "", preferredStyle: .Alert)
      let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
      }
      alertController.addAction(checkAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    } else {
        let storyboard = UIStoryboard(name: "CheckoutCounter", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CheckoutCounterVC") as! CheckoutCounterVC
        vc.hidesBottomBarWhenPushed = true
        vc.locids = userlocids.joinWithSeparator(",")
        navigationController?.pushViewController(vc, animated: true)
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func loadMoreData() {
    page += 1
    loadData(page)
  }
  
  func refreshData() {
    page = 0
    loadData(page)
  }
  
  
  // MARK: - Public
  
  func refresh() {
    // 只有当当前VC可见时才刷新数据
    if isViewLoaded() && (view.window != nil) && !isLoading {
      tabBarItem.badgeValue = nil
      refreshData()
    }
  }
  
  func loadData(page:Int) {
    isLoading = true
    print(AccountInfoManager.sharedInstance.beaconLocationIDs)
    HttpService.sharedInstance.arrivateList(page) { (arrivateArr, error) -> () in
      self.isLoading = false
      if let _  = error {
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      } else {
        if page == 0 {
          self.dataArray.removeAll()
        }
        if let users = arrivateArr where users.count > 0 {
          self.dataArray += users
        }
        if arrivateArr?.count < HttpService.DefaultPageSize {
          self.tableView.mj_footer.hidden = true
        }
        self.tableView?.reloadData()
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
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))  // 上拉加载
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
    cell.delegate = self
    let data = dataArray[indexPath.section]
    cell.setData(data)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! ArrivalCell
    cell.orderButton.tag = indexPath.section
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
  

  
  //TODO GOTOLABELVCDELAGATE
  
  func gotoLabelVC(arrivate:ArrivateModel) {
    
    let storyboard = UIStoryboard(name: "ClientLabelCollectionVC", bundle: nil)
    let ClientVC = storyboard.instantiateViewControllerWithIdentifier("ClientLabelCollectionVC") as! ClientLabelCollectionVC
    ClientVC.clientInfo = arrivate
    ClientVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(ClientVC, animated: true)
  }

  
}

extension ArrivalTVC: CBCentralManagerDelegate {
  
  private func setupBluetoothManager() {
    bluetoothManager = CBCentralManager(delegate: self, queue: nil)
 }
  func centralManagerDidUpdateState(central: CBCentralManager) {
    switch central.state {
    case .PoweredOn:
      BeaconMonitor.sharedInstance.startMonitoring()
      print(".PoweredOn")
    case .PoweredOff:
      BeaconMonitor.sharedInstance.stopMonitoring()
      BeaconMonitor.sharedInstance.beaconInfoCache.removeAll()
      print(".PoweredOff")
    case .Resetting:
      print(".Resetting")
    case .Unauthorized:
      print(".Unauthorized")
    case .Unknown:
      print(".Unknown")
    case .Unsupported:
      print(".Unsupported")
    }
  }

}

