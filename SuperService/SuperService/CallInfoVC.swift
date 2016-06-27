//
//  CallInfoVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class CallInfoVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var callServicesData = [CallServiceModel]()
  var page:Int = 0
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "呼叫通知"
    let nibName = UINib(nibName: CallInfoCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CallInfoCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))  // 上拉加载

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.mj_header.beginRefreshing()
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
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.getCallServicelist("",isowner: false,page: page) { (services, error) in
      if let error = error {
        self.showErrorHint(error)
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      } else {
        if page == 0 {
          self.callServicesData.removeAll()
        }
        if let users = services where users.count > 0 {
          self.callServicesData += users
        } else {
          self.tableView.mj_footer.hidden = true
        }

        if self.callServicesData.count < HttpService.DefaultPageSize {
          self.tableView.mj_footer.hidden = true
        }
        self.tableView?.reloadData()
      }
    }
    self.hideHUD()
    self.tableView.mj_footer.endRefreshing()
    self.tableView.mj_header.endRefreshing()
    
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
    
    cell.serviceStatusChangeSuccessClourse = {(str) -> Void in 
      let titleString = "该任务" + "\(str)"
      let alertController = UIAlertController(title: titleString, message: "", preferredStyle: .Alert)
      let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
        self.refreshData()
      }
      alertController.addAction(checkAction)
      self.presentViewController(alertController, animated: true, completion: nil)
      }
    
    cell.assignBtn.addTarget(self, action: #selector(CallInfoVC.taskActionAssign), forControlEvents: .TouchUpInside)
    cell.assignBtn.tag = indexPath.row
    cell.confing(service)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let service = callServicesData[indexPath.row]
    if service.statuscode == StatusType.Complete {//完成状态不可操作
      return
    }
    let vc = TasktrackingVC()
    if let taskid = service.taskid {
      vc.taskid = taskid
    }
    
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
extension CallInfoVC: XLPagerTabStripChildItem {
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "我的任务"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
}
