//
//  ActivityManagementTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/29.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ActivityManagementTVC: UITableViewController {
  var activityArr = [ActivitymanagerModel]()

  override func viewDidLoad() {
      super.viewDidLoad()
    title = "活动管理"
    let AddActivityButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(ActivityManagementTVC.AddActivity))
    navigationItem.rightBarButtonItem = AddActivityButton
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    tableView.tableFooterView = UIView()

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  }
  
  func loadData() {
    HttpService.sharedInstance.activityManagerlist("") {[weak self] (json, error) in
      guard let strongSelf = self else {return}
      if let error = error {
        strongSelf.showErrorHint(error)
      } else {
        if let data = json {
          strongSelf.activityArr = data
        }
        strongSelf.tableView.reloadData()
      }
    }
  }

  func AddActivity(sender:UIBarButtonItem) {
    let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
    let rolesWithShopVC = storyboard.instantiateViewControllerWithIdentifier("AddactivityTVC") as! AddactivityTVC
    navigationController?.pushViewController(rolesWithShopVC, animated: true)
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return activityArr.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("ActivityManagementTableViewCell", forIndexPath: indexPath) as! ActivityManagementTableViewCell
      let activity = activityArr[indexPath.row]
      cell.textLabel?.text = activity.actname
      cell.creattimeLabel.text = activity.startdate
      return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
    let edit = UITableViewRowAction(style: .Normal, title: "编辑") { action, index in
      self.editActivity(indexPath)
    }
    edit.backgroundColor = UIColor.hx_colorWithHexRGBAString("#03a9f4")
    let checkout = UITableViewRowAction(style: .Normal, title: "取消") { action, index in
      let alertController = UIAlertController(title: "您确定要取消这项活动吗？", message: "", preferredStyle: .Alert)
      let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
      }
      let cancleAction = UIAlertAction(title: "取消", style: .Cancel) { (_) in
        self.view.endEditing(true)
      }
      alertController.addAction(checkAction)
      alertController.addAction(cancleAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    }
    checkout.backgroundColor = UIColor.hx_colorWithHexRGBAString("#e84e40")
    return [checkout,edit]
  }
  
  func editActivity(indexPath:NSIndexPath) {
    let model = activityArr[indexPath.row]
    let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
    let invitationlistVC = storyboard.instantiateViewControllerWithIdentifier("EditActivityTVC") as! EditActivityTVC
    invitationlistVC.avtivityModel = model
    navigationController?.pushViewController(invitationlistVC, animated: true)
  }
    


}
