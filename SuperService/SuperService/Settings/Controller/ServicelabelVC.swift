//
//  ServicelabelVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ServicelabelVC: UITableViewController {

  override func viewDidLoad() {
      super.viewDidLoad()
    title = "服务标签"
    tableView.tableFooterView = UIView()
    
    let AddServicelabeButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(ServicelabelVC.AddServicelabe))
    navigationItem.rightBarButtonItem = AddServicelabeButton
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func AddServicelabe() {
    
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return 4
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
      cell.textLabel?.text = "康体"
      return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    if !TokenPayload.sharedInstance.hasPermission(.DELMEMBER) {
      return []
    } else {
      let more = UITableViewRowAction(style: .Normal, title: "删除") { action, index in
        //删除VIP
       
      }
      more.backgroundColor = UIColor.redColor()
      return [more]
    }
  }
    
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddServerLabelSegue" {
      let addServicelabelVC = segue.destinationViewController as! AddServerlabelVC
      let cell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
      addServicelabelVC.titleString = (cell?.textLabel?.text)!

    }
    
  }



}
