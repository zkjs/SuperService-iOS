//
//  ChoseInvitationTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/30.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ChoseInvitationTVC: UITableViewController {
  var memberArr = [InvitationpersonModel]()
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "邀请名单"
    let nextStepButton = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChoseInvitationTVC.checkoutInvitation))
    navigationItem.rightBarButtonItem = nextStepButton

    tableView.tableFooterView = UIView()
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
    HttpService.sharedInstance.activitymemberlist("") { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
          self.memberArr = data
          self.hideHUD()
          self.tableView.reloadData()
        }
      }
    }
   
  }
  
  func checkoutInvitation(sender:UIBarButtonItem) {
    
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return memberArr.count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("ChoseInvitationCell", forIndexPath: indexPath) as! ChoseInvitationCell
      let person = memberArr[indexPath.row]
      cell.configCell(person)
      return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let member = memberArr[indexPath.row]
    let storyboard = UIStoryboard(name: "ActivityManagementTVC", bundle: nil)
    let personUnderMemberVC = storyboard.instantiateViewControllerWithIdentifier("PersonUnderMemberTVC") as! PersonUnderMemberTVC
    if let members = member.member,let name = member.rolename {
      personUnderMemberVC.memberpersonArr = members
      personUnderMemberVC.titleString = name
    }
    self.navigationController?.pushViewController(personUnderMemberVC, animated: true)

    
  }
    
}
