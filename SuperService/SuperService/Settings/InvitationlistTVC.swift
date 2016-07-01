//
//  InvitationlistTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/30.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class InvitationlistTVC: UITableViewController {
  var invitationArr = [InvitepersonModel]()
  var personcount = ""
  var checkoutpersoncount = ""

  @IBOutlet weak var checkoutperson: UILabel!
  @IBOutlet weak var invitationperson: UILabel!
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "邀请名单"
    tableView.tableFooterView = UIView()
   
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return invitationArr.count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("InvitationlistCell", forIndexPath: indexPath) as! InvitationlistCell
      let person = invitationArr[indexPath.row]
    invitationperson.text = "已邀请" + "\(personcount)"
    checkoutperson.text = "已确认" + "\(checkoutpersoncount)"

      cell.configCell(person)
      return cell
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

      let call = UITableViewRowAction(style: .Normal, title: "呼叫") { action, index in
      }
      call.backgroundColor = UIColor.hx_colorWithHexRGBAString("#ffffff")
      let checkout = UITableViewRowAction(style: .Normal, title: "确认") { action, index in
      }
      call.backgroundColor = UIColor.hx_colorWithHexRGBAString("#888888")
      return [checkout,call]
  }
    

}
