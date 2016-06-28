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
  var secondtagsArr = [ServicetagSecondmodel]()
  var firsttagID:Int!

  @IBOutlet weak var serverlabeltextFlied: UITextField!
  override func viewDidLoad() {
    
    super.viewDidLoad()
    title = titleString
    let endAddServicelabeButton = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddServerlabelVC.complete))
    navigationItem.rightBarButtonItem = endAddServicelabeButton
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    
    tableView.tableFooterView = UIView()

  }
  
  func complete() {
    guard let str = serverlabeltextFlied.text where !str.isEmpty else {
      self.showHint("请填写服务标签")
      return
    }
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.addSecondServiceTag(String(firsttagID), secondSrvTagName: str) { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let secondtag = json {
          self.secondtagsArr.insert(secondtag, atIndex: 0)
          self.tableView.reloadData()
        }
      }
      self.serverlabeltextFlied.text = ""
      self.hideHUD()
      self.tableView.reloadData()
    }
    
  }


  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return secondtagsArr.count - 1
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
        
        let secondtags = self.secondtagsArr[indexPath.row]
        HttpService.sharedInstance.deleteFirstAndSecondTag(String(secondtags.secondSrvTagId!), firstsrvtagid: "", completionHandler: { (json, error) in
          if let error = error {
            self.showErrorHint(error)
          } else {
            if let data = json {
              if data == "success" {
                self.secondtagsArr.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                self.tableView.reloadData() 
              }
           }
            
          }
        })
        
      }
      more.backgroundColor = UIColor.redColor()
      return [more]
    }
  }


    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("addServerLabelCell", forIndexPath: indexPath)
    let tag = secondtagsArr[indexPath.row]
    cell.textLabel?.text = tag.secondSrvTagName
    return cell
  }
    



}
