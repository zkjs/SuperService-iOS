//
//  MessageTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MessageTVC: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "消息通知"
    
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: MessageCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: MessageCell.reuseIdentifier())
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return MessageCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(MessageCell.reuseIdentifier(), forIndexPath: indexPath) as! MessageCell
    
    // Configure the cell...
    
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
