//
//  SettingsVC.swift
//  SuperService
//
//  Created by admin on 15/10/23.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var myView = SettingsHeaderView()
  @IBOutlet weak var tableView: UITableView!

  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("SettingsVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "我的"
    let nibName = UINib(nibName: SettingsCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: SettingsCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.scrollEnabled = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    HttpService.sharedInstance.getUserInfo({ (json, error) -> Void in
      self.tableView.reloadData()
    })
    YunBaService.getTopicList { (topics, error) -> Void in
      if let topics = topics as? [String] {
        for topic in topics {
          print(topic)
        }
      }
    }


  }
  
  
  
  // MARK: - Table View Data Source
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return SettingsCell.height()
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 190
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsCell
    if (indexPath.row == 0){
      cell.textLabel?.text = "设置"
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    if (indexPath.row == 1){
      cell.textLabel?.text = "服务标签"
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    if (indexPath.row == 2){
      cell.textLabel?.text = "活动管理"
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    if (indexPath.row == 3){
      cell.textLabel?.text = "退出登录"
    }
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    myView = (NSBundle.mainBundle().loadNibNamed("SettingsHeaderView", owner: self, options: nil).first as? SettingsHeaderView)!
    myView.userImage.sd_setImageWithURL(NSURL(string: AccountInfoManager.sharedInstance.avatarURL), placeholderImage: UIImage(named: "logo_white"))
    myView.username.text = AccountInfoManager.sharedInstance.userName
    myView.userAddress.text = AccountInfoManager.sharedInstance.fullname
    return myView
  }
  
  
  // MARK - Table View Delegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let setupIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    let ServicelabelIndexPath = NSIndexPath(forItem: 1, inSection: 0)
    let activityIndexPath = NSIndexPath(forItem: 2,inSection: 0)
    let logoutIndexPath = NSIndexPath(forItem: 3, inSection: 0)
    
    if indexPath == logoutIndexPath {
      let alertController = UIAlertController(title: "确定要退出登录吗？", message: "", preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
      let logoutAction = UIAlertAction(title: "退出登录", style:.Destructive, handler: { (action: UIAlertAction) -> Void in
        self.logout()
      })
      alertController.addAction(logoutAction)
      let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      presentViewController(alertController, animated: true, completion: nil)
    }
    
    if indexPath == setupIndexPath {
      let storyboard = UIStoryboard(name: "SettingUpTVC", bundle: nil)
      let vc = storyboard.instantiateViewControllerWithIdentifier("SettingUpTVC") as! SettingUpTVC
      vc.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(vc, animated: true)
    }
    if indexPath == ServicelabelIndexPath {
      let storyboard = UIStoryboard(name: "ServicelabelVC", bundle: nil)
      let servicelabelVC = storyboard.instantiateViewControllerWithIdentifier("ServicelabelVC") as! ServicelabelVC
      servicelabelVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(servicelabelVC, animated: true)
    }
    if indexPath == activityIndexPath {
      let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
      let activityVC = storyboard.instantiateViewControllerWithIdentifier("ActivityManagementTVC") as! ActivityManagementTVC
      activityVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
  }
  
  func logout() {
    showHUDInView(view, withLoading: "正在退出登录...")
    // 清理系统缓存
    if let a:String =  StorageManager.sharedInstance().ispasswordAndusername() where a.isEmpty == false {
      StorageManager.sharedInstance().clearloginStatus()
    }
    AccountInfoManager.sharedInstance.clearAccountCache()
    StorageManager.sharedInstance().clearNoticeArray()
    StorageManager.sharedInstance().clearnearBeaconLocid()
    TokenPayload.sharedInstance.clearCacheTokenPayload()
    StorageManager.sharedInstance().savePresentInfoVC(true)
    // 消除订阅云巴频道
    YunbaSubscribeService.sharedInstance.unsubscribeAllTopics()
    
    // 登出环信
    EaseMob.sharedInstance().chatManager.removeAllConversationsWithDeleteMessages!(true, append2Chat: true)
    let error: AutoreleasingUnsafeMutablePointer<EMError?> = nil
    print("登出前环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true)
    print("登出后环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    self.hideHUD()
    if error != nil {
      self.showHint(error.debugDescription)
    } else {
      NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
    }
    showAdminLogin()
  }

  
  func showAdminLogin() {
    let vc = StaffLoginVC()
    let nv = BaseNavigationController(rootViewController: vc)
    presentViewController(nv, animated: true, completion: nil)
  }
  
}
