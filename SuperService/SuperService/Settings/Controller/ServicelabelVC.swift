//
//  ServicelabelVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ServicelabelVC: UITableViewController {
  var tagsArr = [ServicetagFirstModel]()
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "服务标签"
    tableView.tableFooterView = UIView()
    
    let AddServicelabeButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(ServicelabelVC.AddServicelabel))
    navigationItem.rightBarButtonItem = AddServicelabeButton
    
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  }
  
  func loadData() {
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.servicetags("") {[weak self] (data, error) in
      guard let strongSelf = self else {return}
      if let error = error {
        strongSelf.showErrorHint(error)
        strongSelf.hideHUD()
      } else {
        if let a = data {
          strongSelf.tagsArr = a
        }
      }
      strongSelf.hideHUD()
      strongSelf.tableView.reloadData()
      
    }
  }

  func AddServicelabel() {
    let storyboard = UIStoryboard(name: "ServicelabelVC", bundle: nil)
    let rolesWithShopVC = storyboard.instantiateViewControllerWithIdentifier("RolesWithShopTVC") as! RolesWithShopTVC
    navigationController?.pushViewController(rolesWithShopVC, animated: true)
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tagsArr.count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
      let firsttag = tagsArr[indexPath.row]
      cell.textLabel?.text = firsttag.firstSrvTagName
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
        let firsttag = self.tagsArr[indexPath.row]
        HttpService.sharedInstance.deleteFirstAndSecondTag("", firstsrvtagid: String(firsttag.firstSrvTagId!), completionHandler: { (json, error) in
          if let error = error {
            self.showErrorHint(error)
          } else {
            if let data = json {
              if data == "success" {
                self.tagsArr.removeAtIndex(indexPath.row)
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
    
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddServerLabelSegue" {
      let addServicelabelVC = segue.destinationViewController as! AddServerlabelVC
      let cell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
      addServicelabelVC.titleString = (cell?.textLabel?.text)!
      if let a:ServicetagFirstModel = tagsArr[(tableView.indexPathForSelectedRow?.row)!],let str = a.firstSrvTagId,let secondtags = a.secondSrvTag {
        addServicelabelVC.firsttagID = str
        addServicelabelVC.secondtagsArr = secondtags
      }

    }
    
  }



}
