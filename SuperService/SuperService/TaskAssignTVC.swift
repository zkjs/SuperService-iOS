//
//  TaskAssignTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/25.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskAssignTVC: UITableViewController {
  let collation = UILocalizedIndexedCollation.currentCollation()
  var service =  CallServiceModel(dic:nil)
  var sections = [String:[TeamModel]]()
  var teamArray = [TeamModel]() {
    didSet {
      
      sections.removeAll()
      for m in teamArray {
        let role = m.displayRoleName
        if sections[role] == nil {
          sections[role] = [TeamModel]()
        }
        if !sections[role]!.contains(m) {
          sections[role]?.append(m)
        }
      }
      
      sectionTitleArr = teamArray.flatMap{ $0.displayRoleName }
        .reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
        .map{ ($0.firstCharactor,$0) }
        .sort{ $0.0 < $1.0 }
    }
  }
  var sectionTitleArr = [(String,String)]()
  var rolesArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
      title = "指派"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  } 
  
  func loadData() {
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.queryTeamsInfo {[weak self] (teams, error) -> () in
      guard let strongSelf = self else {return}
      if let error = error {
        strongSelf.showErrorHint(error)
        strongSelf.hideHUD()
      } else {
        if let users = teams where users.count > 0 {
          strongSelf.teamArray.removeAll()
          strongSelf.teamArray = users
          strongSelf.tableView?.reloadData()
          strongSelf.hideHUD()
        }
      }
    }
    
  }

    // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return sections.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let role = sectionTitleArr[section].1
    return sections[role]?.count ?? 0
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TaskAssignCell", forIndexPath: indexPath) as! TaskAssignCell
    let role = sectionTitleArr[indexPath.section].1
    if let team = sections[role]?[indexPath.row] {
      cell.congfigCell(team)
    }
    return cell
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitleArr[section].1
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let role = sectionTitleArr[indexPath.section].1
    if let team = sections[role]?[indexPath.row] {
      guard let name = team.username else {return}
      let title = "将任务指派给" + "\(name)"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .Alert)
      let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
        HttpService.sharedInstance.servicetaskStatusChange(self.service.taskid!, operationseq: String(self.service.operationseq!), taskaction: 2, target: team.userid!, targetIsNeeded: true, completionHandler: { (json, error) in
          if let data = json {
          if data == "success" {
            self.navigationController?.popToRootViewControllerAnimated(true)
           }
          }
        })
      }
      let cancleAction = UIAlertAction(title: "取消", style: .Default) { (_) in
        self.dismissViewControllerAnimated(true, completion: nil)
      }
      alertController.addAction(cancleAction)
      alertController.addAction(checkAction)
      self.presentViewController(alertController, animated: true, completion: nil)
    }
      
   }

}
