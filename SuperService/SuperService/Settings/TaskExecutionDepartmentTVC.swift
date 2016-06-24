//
//  TaskExecutionDepartmentTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskExecutionDepartmentTVC: UITableViewController {

  var departmentArr = [RolesWithShopModel]()
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "任务执行部门"
    let rightbarItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TaskExecutionDepartmentTVC.complete))
    navigationItem.rightBarButtonItem = rightbarItem
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    
    tableView.tableFooterView = UIView()


  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  }
  
  func complete() {
    
  }
  
  func loadData() {
    HttpService.sharedInstance.rolesWithshops { (data, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let department = data {
          self.departmentArr = department
        }
      }
      self.tableView.reloadData()
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      return departmentArr.count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("TaskExecutionDepartmentCell", forIndexPath: indexPath) as! TaskExecutionDepartmentCell
      let department = departmentArr[indexPath.row]
      cell.congfigCell(department)
      return cell
  }
    

    

}
