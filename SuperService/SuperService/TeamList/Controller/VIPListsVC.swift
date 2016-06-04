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
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.mj_header.beginRefreshing()
    self.VIPList.removeAll()
    self.tableView.reloadData()
    
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
          strongSelf.tableView?.reloadData()
        } else {
          strongSelf.page -= 1
        }
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
    cell.label.translatesAutoresizingMaskIntoConstraints = false
    cell.VIPMarkLabel.translatesAutoresizingMaskIntoConstraints = false
    cell.layer.masksToBounds = true
    cell.selectionStyle = UITableViewCellSelectionStyle.None

    let VIP = VIPList[indexPath.row]
    if selectedCellIndexPaths.contains(indexPath) {
      cell.VIPMarkLabel.hidden = false
      cell.label.hidden = false
    } else {
      cell.VIPMarkLabel.hidden = true
      cell.label.hidden = true
    }
    cell.configCell(VIP)

    
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
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

  }

  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let more = UITableViewRowAction(style: .Normal, title: "删除") { action, index in
      //删除VIP
      self.DeleteVIP(indexPath)
    }
    more.backgroundColor = UIColor.redColor()
    return [more]
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

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if selectedCellIndexPaths.contains(indexPath) {
      return 139
    }
    return 80
  }

  // MARK: - XLPagerTabStripChildItem Delegate

  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "会员"
  }

  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
}
