//
//  MessageTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MessageTVC: UITableViewController {
  
  var dataArray = [Conversation]()
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("MessageTVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "refresh",
      name: kRefreshConversationListNotification,
      object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    refresh()
    resetTabBadge()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  // MARK: - Public
  
  func refresh() {
    if let dataArray = Persistence.sharedInstance().fetchConversationArray() {
      self.dataArray = dataArray
      tableView.reloadData()
    }
  }
  
  
  // MARK: - Private
  
  private func setupView() {
    title = "消息"
    
    let nibName = UINib(nibName: MessageCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: MessageCell.reuseIdentifier())
    
    tableView.tableFooterView = UIView()
  }
  
  private func resetTabBadge() {
    let tabArray = super.tabBarController?.tabBar.items as NSArray!
    let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
    tabItem.badgeValue = nil
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return MessageCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(MessageCell.reuseIdentifier(), forIndexPath: indexPath) as! MessageCell
    
    let data = dataArray[indexPath.row]
    cell.setData(data)
    
    return cell
  }
  
  
  // MARK: - Table view delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let data = dataArray[indexPath.row]
    let vc = JSHChatVC()
    vc.sessionID = data.sessionID
    vc.receiverID = data.otherSideID
    vc.receiverName = data.otherSideName
    
    hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
    hidesBottomBarWhenPushed = false
  }
  
}
