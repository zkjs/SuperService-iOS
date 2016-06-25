//
//  TaskExecutionDepartmentTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskExecutionDepartmentTVC: UITableViewController {
  var selectedDepartmentArray = [Int]()
  var selectedArray = [Int]()
  var departmentArr = [RolesWithShopModel]()
  var selectedAreaArr = [String]()
  var selectedRolesArr = [String]()
  var firstSrvTagName = ""
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
    let dic = ["firstSrvTagName":firstSrvTagName,"roleids":self.selectedDepartmentArray,"ownerids":selectedRolesArr,"locids":selectedAreaArr]
    HttpService.sharedInstance.addFirstserviceTag(dic) { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        self.navigationController?.popToRootViewControllerAnimated(true)
      }
    }
  }
  
  func loadData() {
    selectedDepartmentArray.removeAll()
    HttpService.sharedInstance.rolesWithshops { (data, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let department = data {
          self.departmentArr = department
        }
      }
      self.initSelectedArray()
      self.tableView.reloadData()
    }
  }
  
  func initSelectedArray() {
    for index in 0..<departmentArr.count {
      if selectedDepartmentArray.contains(departmentArr[index].roleid!) {
        selectedArray.append(index)
      }
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
      cell.departmentButton.addTarget(self, action: #selector(TaskExecutionDepartmentTVC.tappedCellSelectedButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      cell.departmentButton.tag = indexPath.row
      if selectedDepartmentArray.contains(department.roleid!) {
        cell.isUncheck = false
        cell.departmentButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
      } else {
        cell.isUncheck = true
        cell.departmentButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
      }

      return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! TaskExecutionDepartmentCell
    cell.changeSelectedButtonImage()
    updateSelectedArrayWithCell(cell)
  }
  
  func tappedCellSelectedButton(sender: UIButton) {
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! TaskExecutionDepartmentCell
    updateSelectedArrayWithCell(cell)
  }

  func updateSelectedArrayWithCell(cell: TaskExecutionDepartmentCell) {
    
    let department = departmentArr[cell.departmentButton.tag]
    if cell.isUncheck == false {
      self.selectedArray.append(cell.departmentButton.tag)
      selectedDepartmentArray.append(department.roleid!)
    } else {
      if let index = selectedArray.indexOf(cell.departmentButton.tag) {
        selectedArray.removeAtIndex(index)
        for (index, value) in selectedDepartmentArray.enumerate() {
          if selectedDepartmentArray.count == 1 {
            selectedDepartmentArray.removeAtIndex(0)
            return
          }
          if case department.roleid! = value {
            selectedDepartmentArray.removeAtIndex(index)
            print(selectedDepartmentArray)
            print("Found \(value) at position \(index)")
          }
        }
      }
    }
  }

}
