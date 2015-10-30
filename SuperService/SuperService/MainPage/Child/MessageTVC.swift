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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "消息"
    
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: MessageCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: MessageCell.reuseIdentifier())
    
    if let dataArray = Persistence.sharedInstance().fetchConversationArray() {
      self.dataArray = dataArray
    }
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
    
//    let vc = UIViewController()
//    vc.view.backgroundColor = UIColor.blackColor()
//    
//    navigationController?.pushViewController(vc, animated: true)
  }
  
}
