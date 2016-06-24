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
  var taskid = 0

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
    HttpService.sharedInstance.servicetaskDetail(taskid) { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
          let taskDetail = data
        }
      }
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
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
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(TasktrackingCell.reuseIdentifier(), forIndexPath: indexPath) as! TasktrackingCell
      let firstRow = NSIndexPath(forRow: 0, inSection: 1)
      if indexPath == firstRow {
        cell.topLabel.hidden = true
      } else {
        cell.topLabel.hidden = false
      }
      return cell
    }
    
  }
}
