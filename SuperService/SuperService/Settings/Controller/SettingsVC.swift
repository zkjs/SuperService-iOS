//
//  SettingsVC.swift
//  SuperService
//
//  Created by admin on 15/10/23.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
  
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
    return 5
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
      cell.textLabel?.text = "管理"
    }
    if (indexPath.row == 1){
      cell.textLabel?.text = "设置"
    }
    if (indexPath.row == 2){
      cell.textLabel?.text = "上班状态"
    }
    if (indexPath.row == 3){
      cell.textLabel?.text = "关于我们"
    }
    if (indexPath.row == 4){
      cell.textLabel?.text = "登出"
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let myView = NSBundle.mainBundle().loadNibNamed("SettingsHeaderView", owner: self, options: nil).first as? SettingsHeaderView
    if myView != nil {
      let userID = AccountManager.sharedInstance().userID
      let url = NSURL(string: kBaseURL)
      if let url = url?.URLByAppendingPathComponent("uploads/users/\(userID).jpg") {
        
        if let data = NSData(contentsOfURL: url),
          let image = UIImage(data: data) {
            myView?.userImage.image = image
        }
      }
      myView?.username.text = AccountManager.sharedInstance().userName
      myView?.userAddress.text = AccountManager.sharedInstance().shopName
      self.view.addSubview(myView!)
    }
    return myView
  }
  
  
  //MARK -- Table View Delegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let logoutIndexPath = NSIndexPath(forItem: 4, inSection: 0)
    let setupIndexPath = NSIndexPath(forItem: 1, inSection: 0)
    if indexPath == logoutIndexPath {
      let alertController = UIAlertController(title: "确定要登出吗？", message: "", preferredStyle: .ActionSheet)
      
      let logoutAction = UIAlertAction(title: "登出", style:.Destructive, handler: { (action: UIAlertAction) -> Void in
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
      self.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(vc, animated: true)
      self.hidesBottomBarWhenPushed = false
    }
  }
  
  func logout() {
    AccountManager.sharedInstance().clearAccountCache()
    showAdminLogin()
  }
  
  func showAdminLogin() {
    let vc = StaffLoginVC()
    let nv = UINavigationController(rootViewController: vc)
    nv.navigationBar.barTintColor = UIColor(hexString: "29B6F6")
    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
    nv.navigationBar.translucent = false
    presentViewController(nv, animated: true, completion: nil)
    
  }
  
}
