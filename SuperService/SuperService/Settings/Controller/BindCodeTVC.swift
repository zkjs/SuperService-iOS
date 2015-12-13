//
//  BindCodeTVC.swift
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit
import MessageUI

class BindCodeTVC: UITableViewController {
  
  let shareTypes = ["短信", "微信好友"]
  
  var page = 1
  lazy var codeArray = [BindCodeModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: CodeCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CodeCell.reuseIdentifier())
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
    
    tableView.mj_header.beginRefreshing()
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return codeArray.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CodeCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(BindCodeCell.reuseIdentifier(), forIndexPath: indexPath) as! BindCodeCell
    let code = codeArray[indexPath.row]
    cell.setData(code)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func loadMoreData() {
    loadData(page)
  }
  
  func refreshData() {
    page = 1
    codeArray.removeAll()
    loadData(page)
  }
  
  func loadData(page:AnyObject) {
    ZKJSHTTPSessionManager.sharedInstance().getAllCodeUserWithPage(String(page), success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let data = responseObject {
        if let array = data["data"] as? [[String: AnyObject]] {
          for dict in array {
            let code = BindCodeModel(dic: dict)
            self.codeArray.append(code)
          }
          self.tableView.reloadData()
          self.page++
        }
      }
      self.tableView.mj_footer.endRefreshing()
      self.tableView.mj_header.endRefreshing()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
  }
  
}

extension BindCodeTVC: XLPagerTabStripChildItem {
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "已使用"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
}