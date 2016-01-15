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
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  
  // MARK: - Table View Data Source
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
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
    }
    if (indexPath.row == 1){
      cell.textLabel?.text = "关于我们"
    }
    if (indexPath.row == 2){
      cell.textLabel?.text = "退出登录"
    }
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     myView = (NSBundle.mainBundle().loadNibNamed("SettingsHeaderView", owner: self, options: nil).first as? SettingsHeaderView)!
    print(AccountManager.sharedInstance().avatarImage)
    myView.userImage.image = AccountManager.sharedInstance().avatarImage
    myView.username.text = AccountManager.sharedInstance().userName
    myView.userAddress.text = AccountManager.sharedInstance().shopName
    return myView
  }
  
  
  // MARK - Table View Delegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let setupIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    let aboutUSIndexPath = NSIndexPath(forItem: 1, inSection: 0)
    let logoutIndexPath = NSIndexPath(forItem: 2, inSection: 0)
    if indexPath == logoutIndexPath {
      let alertController = UIAlertController(title: "确定要退出登录吗？", message: "", preferredStyle: .ActionSheet)
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
    if indexPath == aboutUSIndexPath {
      let vc = AboutUSVC()
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func logout() {
    showHUDInView(view, withLoading: "正在退出登录...")
    AccountManager.sharedInstance().clearAccountCache()
    self.unregisterYunBaTopic()
    EaseMob.sharedInstance().chatManager.removeAllConversationsWithDeleteMessages!(true, append2Chat: true)
    EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true, completion: { (info: [NSObject : AnyObject]!, error: EMError!) -> Void in
      self.hideHUD()
      if error != nil && error.errorCode != .ServerNotLogin {
        self.showHint(error.description)
      } else {
        NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
      }
      }, onQueue: nil)
    showAdminLogin()
  }
  
  func unregisterYunBaTopic() {
    let locid = AccountManager.sharedInstance().beaconLocationIDs
    let topicArray = locid.componentsSeparatedByString(",")
    for topic in topicArray {
      YunBaService.unsubscribe(topic) { (success: Bool, error: NSError!) -> Void in
        if success {
          print("[result] unsubscribe to topic(\(topic)) succeed")
        } else {
          print("[result] unsubscribe to topic(\(topic)) failed: \(error), recovery suggestion: \(error.localizedRecoverySuggestion)")
        }
      }
    }
  }
  
  func showAdminLogin() {
    let vc = StaffLoginVC()
    let nv = UINavigationController(rootViewController: vc)
    nv.navigationBar.barTintColor = UIColor.ZKJS_themeColor()
    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    nv.navigationBar.translucent = false
    presentViewController(nv, animated: true, completion: nil)
  }
  
}
