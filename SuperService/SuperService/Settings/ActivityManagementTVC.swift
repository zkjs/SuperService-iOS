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
    HttpService.sharedInstance.activityManagerlist("") { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
          self.activityArr = data
        }
        self.tableView.reloadData()
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
      return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
    


}
