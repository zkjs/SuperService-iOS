//
//  TasktrackingVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TasktrackingVC: UIViewController {
  var taskDetail = TasktrackingModel()
  var taskid = ""

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "任务追踪"
    let nibName1 = UINib(nibName: TasktrackingCell.nibName(), bundle: nil)
    tableView.registerNib(nibName1, forCellReuseIdentifier: TasktrackingCell.reuseIdentifier())
    let nibName2 = UINib(nibName: TasktrackingInfoCell.nibName(), bundle: nil)
    tableView.registerNib(nibName2, forCellReuseIdentifier: TasktrackingInfoCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  }
  
  func loadData() {
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.servicetaskDetail(taskid) { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
           self.taskDetail = data
           self.tableView.reloadData()
        }
      }
      self.hideHUD()
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      if let count = taskDetail.historyData?.count {
        return count
      } else {
        return 0
      }
    }
    
  }
  
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 80
    } else {
      return TasktrackingCell.height()
    }
  }
  
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier(TasktrackingInfoCell.reuseIdentifier(), forIndexPath: indexPath) as! TasktrackingInfoCell
      cell.configSectionHeader(self.taskDetail)
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(TasktrackingCell.reuseIdentifier(), forIndexPath: indexPath) as! TasktrackingCell
      let firstRow = NSIndexPath(forRow: 0, inSection: 1)
      if let a:Int = taskDetail.historyData!.count {
        let lastRow = NSIndexPath(forRow: a-1, inSection: 1)
        if indexPath == lastRow {
          cell.bottomLabel.hidden = true
        } else {
          cell.bottomLabel.hidden = false
        }
      }
      if indexPath == firstRow {
        cell.topLabel.hidden = true
      } else {
        cell.topLabel.hidden = false
      }
      if let arr = taskDetail.historyData {
        let task = arr[indexPath.row]
        cell.configCell(task)
      }
     
      return cell
    }
    
  }
}
