//
//  VIPListsVC.swift
//  SuperService
//
//  Created by AlexBang on 16/5/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class VIPListsVC: UIViewController,XLPagerTabStripChildItem {

  @IBOutlet weak var tableView: UITableView!
  var selectedCellIndexPaths:[NSIndexPath] = []
  var VIPList = [AddClientModel]()
  var page:Int = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "会员"
    let nibName = UINib(nibName: VIPCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: VIPCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(VIPListsVC.refresh))  // 下拉刷新
    tableView.mj_footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(VIPListsVC.loadMoreData)) //上拉加载
    tableView.mj_header.beginRefreshing()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120.0
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.mj_header.beginRefreshing()
  }
  
  func loadMoreData() {
    page += 1
    loadData(page)
  }
  
  func refresh() {
    page = 0
    loadData(page)
  }
  
  func loadData(page:Int) {
    HttpService.sharedInstance.whiteUsersList(page) {[weak self] (VIPUser, error) -> () in
      guard let strongSelf = self else {return}
      if let _ = error {
        strongSelf.tableView.mj_footer.endRefreshing()
        strongSelf.tableView.mj_header.endRefreshing()
      } else {
        if page == 0 {
          strongSelf.VIPList.removeAll()
        }
        if let users = VIPUser where users.count > 0 {
          strongSelf.VIPList += users
        } else {
          strongSelf.page -= 1
        }
        strongSelf.tableView?.reloadData()
      }
    }
    
    self.tableView.mj_header.endRefreshing()
    self.tableView.mj_footer.endRefreshing()
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("VIPListsVC", owner:self, options:nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return VIPList.count
  }


  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(VIPCell.reuseIdentifier(), forIndexPath: indexPath) as! VIPCell
    cell.layer.masksToBounds = true
    cell.selectionStyle = UITableViewCellSelectionStyle.None

    let VIP = VIPList[indexPath.row]
    cell.configCell(VIP)
    if selectedCellIndexPaths.contains(indexPath) {
      cell.VIPMarkLabel.text = VIP.rmk
      cell.VIPPhoneLabel.text = VIP.phone
      cell.phoneLabel.text = "电话:"
      cell.label.text = "备注:"
      cell.topConstraint.constant = 15
      cell.bottomConstraint.constant = 20
    } else {
      cell.bottomConstraint.constant = 0
      cell.topConstraint.constant = 0
      cell.VIPMarkLabel.text = ""
      cell.label.text = ""
      cell.VIPPhoneLabel.text = ""
      cell.phoneLabel.text = ""
    }
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)

    if let index = selectedCellIndexPaths.indexOf(indexPath) {
      selectedCellIndexPaths.removeAtIndex(index)
    }else{
      selectedCellIndexPaths.append(indexPath)
    }
    // Forces the table view to call heightForRowAtIndexPath
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // 要显示自定义的action,cell必须处于编辑状态
    return TokenPayload.sharedInstance.hasPermission(.DELMEMBER)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

  }

  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    if !TokenPayload.sharedInstance.hasPermission(.DELMEMBER) {
      return []
    } else {
      let more = UITableViewRowAction(style: .Normal, title: "删除") { action, index in
        //删除VIP
        self.DeleteVIP(indexPath)
      }
      more.backgroundColor = UIColor.redColor()
      return [more]
    }
  }

  func DeleteVIP(indexPath:NSIndexPath) {
      let VIP = self.VIPList[indexPath.row]
      guard let userid = VIP.userid,let phone = VIP.phone else {return}
      HttpService.sharedInstance.deleteWhiteUser(userid, phone: phone, completionHandler: { (json, error) -> () in
        if let error = error {
          self.showErrorHint(error)
        } else {
          if let _ = json {
            self.VIPList.removeAtIndex(indexPath.row) 
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.tableView.reloadData() 
          }
        }
      })
    }

  // MARK: - XLPagerTabStripChildItem Delegate

  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "会员"
  }

  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
}