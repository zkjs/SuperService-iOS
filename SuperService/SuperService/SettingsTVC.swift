//
//  SettingsTVC.swift
//  SuperService
//
//  Created by  on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "我的"
    
    tableView.tableFooterView = UIView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let logoutIndexPath = NSIndexPath(forRow: 4, inSection: 0)
    if indexPath == logoutIndexPath {
      let alertController = UIAlertController(title: "确定登出吗?", message: "", preferredStyle: .ActionSheet)
      
      let logoutAction = UIAlertAction(title: "登出", style: .Destructive, handler: {[unowned self] (action: UIAlertAction) -> Void in
        self.logout()
      })
      alertController.addAction(logoutAction)
      
      let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      
      presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    let statusIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    if indexPath == statusIndexPath {
      return nil
    }
    return indexPath
  }
  
  // MARK: - Private
  
  func logout() {
    AccountManager.sharedInstance().clearAccountCache()
    showAdminLogin()
  }
  
  func showAdminLogin() {
    let storyboard = UIStoryboard(name: "AdminLogin", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("AdminLoginVC") as! AdminLoginVC
    let nv = UINavigationController(rootViewController: vc)
    nv.navigationBar.barTintColor = UIColor(hexString: "29B6F6")
    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    nv.navigationBar.translucent = false
    presentViewController(nv, animated: true, completion: nil)
  }
  
}
