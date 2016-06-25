//
//  SelectServiceAreaTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class SelectServiceAreaTVC: UITableViewController {
  var selectedRolesArr = [String]()
  var selectedAreaArray = [String]()
  var areaArray = [AreaModel]()
  var selectedArray = [Int]()
  var firstSrvTagName = ""
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "选择服务区域"
    let rightbarItem = UIBarButtonItem.init(title: "跳过", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SelectServiceAreaTVC.skip))
    navigationItem.rightBarButtonItem = rightbarItem
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))  // 上拉加载
  }
  
 
  
  func loadMoreData() {
    page += 1
    loadData(page)
  }
  
  func refreshData() {
    page = 0
    loadData(page)
  }
  
  func loadData(page:Int) {
    self.selectedAreaArray.removeAll()
    HttpService.sharedInstance.getSubscribeList(page) { (json, error) -> Void in
      if let _ = error {
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      } else {
        if page == 0 {
          self.areaArray.removeAll()
        }
        if let jsonArr = json!["data"].array {
          for dict in jsonArr {
            let area = AreaModel(dic: dict)
            self.areaArray.append(area)
            
          }
          if jsonArr.count < HttpService.DefaultPageSize {
            self.tableView.mj_footer.hidden = true
          }
          self.initSelectedArray()  // Model
          self.tableView.reloadData()  // UI
        }
      }
    }
    
    self.tableView.reloadData()
    self.tableView.mj_footer.endRefreshing()
    self.tableView.mj_header.endRefreshing()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    tableView.mj_header.beginRefreshing()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func initSelectedArray() {
    for index in 0..<areaArray.count {
      if selectedAreaArray.contains(areaArray[index].locid!) {
        selectedArray.append(index)
      }
    }
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return areaArray.count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SelectServiceAreaCell", forIndexPath: indexPath) as! SelectServiceAreaCell
    let area = areaArray[indexPath.row]
    cell.selectedButton.addTarget(self, action: #selector(SelectServiceAreaTVC.tappedCellSelectedButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    cell.selectedButton.tag = indexPath.row
    if selectedAreaArray.contains(area.locid!) {
      cell.isUncheck = false
      cell.selectedButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    } else {
      cell.isUncheck = true
      cell.selectedButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
    }
    
    cell.setData(area)

    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectServiceAreaCell
    cell.changeSelectedButtonImage()
    updateSelectedArrayWithCell(cell)
  }
  
  func tappedCellSelectedButton(sender: UIButton) {
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! SelectServiceAreaCell
    updateSelectedArrayWithCell(cell)
  }
  
  func updateSelectedArrayWithCell(cell: SelectServiceAreaCell) {
    
    let area = areaArray[cell.selectedButton.tag]
    if cell.isUncheck == false {
      self.selectedArray.append(cell.selectedButton.tag)
      selectedAreaArray.append(area.locid!)
    } else {
      if let index = selectedArray.indexOf(cell.selectedButton.tag) {
        selectedArray.removeAtIndex(index)
        for (index, value) in selectedAreaArray.enumerate() {
          if selectedAreaArray.count == 1 {
            selectedAreaArray.removeAtIndex(0)
            return
          }
          if case area.locid! = value {
            selectedAreaArray.removeAtIndex(index)
            print(selectedAreaArray)
            print("Found \(value) at position \(index)")
            
          }
        }
      }
    }
    if selectedAreaArray.count > 0 {
      let rightbarItem = UIBarButtonItem.init(title: "下一步", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SelectServiceAreaTVC.selectedServiceArea))
      navigationItem.rightBarButtonItem = rightbarItem
    } else {
      let rightbarItem = UIBarButtonItem.init(title: "跳过", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SelectServiceAreaTVC.skip))
      navigationItem.rightBarButtonItem = rightbarItem
    }
    
  }
  
  //跳过
  func skip() {

    let storyboard = UIStoryboard(name: "ServicelabelVC", bundle: nil)
    let taskExecutionDepartmentVC = storyboard.instantiateViewControllerWithIdentifier("TaskExecutionDepartmentTVC") as! TaskExecutionDepartmentTVC
    taskExecutionDepartmentVC.firstSrvTagName = self.firstSrvTagName
    taskExecutionDepartmentVC.selectedRolesArr = self.selectedRolesArr
    navigationController?.pushViewController(taskExecutionDepartmentVC, animated: true)
  }
  
  func selectedServiceArea() {
    let storyboard = UIStoryboard(name: "ServicelabelVC", bundle: nil)
    let taskExecutionDepartmentVC = storyboard.instantiateViewControllerWithIdentifier("TaskExecutionDepartmentTVC") as! TaskExecutionDepartmentTVC
    taskExecutionDepartmentVC.firstSrvTagName = self.firstSrvTagName
    taskExecutionDepartmentVC.selectedAreaArr = self.selectedAreaArray
    taskExecutionDepartmentVC.selectedRolesArr = self.selectedRolesArr
    navigationController?.pushViewController(taskExecutionDepartmentVC, animated: true)
  }

    

}
