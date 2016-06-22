//
//  AddServerlabelVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class AddServerlabelVC: UITableViewController {
  var titleString:String!

  @IBOutlet weak var serverlabeltextFlied: UITextField!
  override func viewDidLoad() {
    
    super.viewDidLoad()
    title = titleString
    let endAddServicelabeButton = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddServerlabelVC.complete))
    navigationItem.rightBarButtonItem = endAddServicelabeButton
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item

  }
  
  func complete() {
    guard let str = serverlabeltextFlied.text where !str.isEmpty else {
      self.showHint("请填写服务标签")
      return
    }
      
    
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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


    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("addServerLabelCell", forIndexPath: indexPath)
    cell.textLabel?.text = "按摩洗脚大保健呵呵"
    return cell
  }
    



}
