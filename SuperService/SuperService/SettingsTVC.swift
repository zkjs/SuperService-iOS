//
//  SettingsTVC.swift
//  SuperService
//
//  Created by  on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "我的"
    
    tableView.tableFooterView = UIView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    let statusIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    if indexPath == statusIndexPath {
      return nil
    }
    return indexPath
  }
  
}
