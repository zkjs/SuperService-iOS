//
//  CallInfoVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskListVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var callServicesData = [CallServiceModel]()
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "指派任务"
    let nibName = UINib(nibName: CallInfoCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CallInfoCell.reuseIdentifier())
    tableView.tableFooterView = UIView()

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
    
  }
  
  func loadData() {
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.getCallServicelist("",isowner: true) { (services, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = services {
          self.callServicesData = data
          self.tableView.reloadData()
        }
      }
    }
    self.hideHUD()
    
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("CallInfoVC", owner:self, options:nil)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return callServicesData.count
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CallInfoCell.height()
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CallInfoCell.reuseIdentifier(), forIndexPath: indexPath) as! CallInfoCell
    let firstRow = NSIndexPath(forRow: 0, inSection: 0)
    if indexPath == firstRow {
      cell.topLineImageView.hidden = true
    } else {
      cell.topLineImageView.hidden = false
    }
    let service = callServicesData[indexPath.row]
    cell.confing(service)
    
    if service.statuscode == StatusType.Complete {//完成状态不可操作
      cell.endServerBtn.enabled = false
      cell.endServerBtn.tintColor = UIColor.hx_colorWithHexRGBAString("#888888")
      cell.assignBtn.enabled = false
      cell.assignBtn.tintColor = UIColor.hx_colorWithHexRGBAString("#888888")
      cell.beReadyBtn.enabled = false
      cell.beReadyBtn.tintColor = UIColor.hx_colorWithHexRGBAString("#888888")
    }
    
    cell.serviceStatusChangeSuccessClourse = {(str) -> Void in 
      let titleString = "该任务" + "\(str)"
      let alertController = UIAlertController(title: titleString, message: "", preferredStyle: .Alert)
      let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
        self.loadData()
      }
      alertController.addAction(checkAction)
      self.presentViewController(alertController, animated: true, completion: nil)
      }
    cell.assignBtn.addTarget(self, action: #selector(CallInfoVC.taskActionAssign), forControlEvents: .TouchUpInside)
    cell.assignBtn.tag = indexPath.row
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let service = callServicesData[indexPath.row]
    if service.statuscode == StatusType.Complete {//完成状态不可操作
      return
    }
    let vc = TasktrackingVC()
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
    
  }
  
  
  func taskActionAssign(sender:UIButton) {
    let service = callServicesData[sender.tag]
    let storyboard = UIStoryboard(name: "TaskAssignTVC", bundle: nil)
    let taskassignVC = storyboard.instantiateViewControllerWithIdentifier("TaskAssignTVC") as! TaskAssignTVC
    taskassignVC.service = service
    taskassignVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(taskassignVC, animated: true)
  }
  
    

}

// MARK: - XLPagerTabStripChildItem Delegate
extension TaskListVC: XLPagerTabStripChildItem {
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "指派任务"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
}
