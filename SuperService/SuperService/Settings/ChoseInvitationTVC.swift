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
  var actname:String!
  var actcontent:String!
  var startdate:String!
  var enddate:String!
  var actimage:UIImage!
  var maxtake:Int!
  var acturl:String!
  var portable:Int!

   
  var isSelectedAllperson = true
  
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "邀请名单"
    let nextStepButton = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChoseInvitationTVC.checkoutInvitation))
    navigationItem.rightBarButtonItem = nextStepButton
    loadData()
    tableView.tableFooterView = UIView()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  func loadData() {
    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.activitymemberlist("") { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
          self.memberArr = data
        }
      }
      self.hideHUD()
      self.tableView.reloadData()
    }
   
  }
  
  func checkoutInvitation(sender:UIBarButtonItem) {
    let members = memberArr.flatMap{ $0.selectedMembers() }.map{ $0.userid }
    let str = members.joinWithSeparator(",")
    HttpService.sharedInstance.createActivity("", actname: actname, actcontent: actcontent, startdate: startdate, enddate: enddate, acturl: acturl, invitesi: str, portable: self.portable == 1, maxtake: maxtake, image: actimage) { (json, error) in
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json {
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
      }
    }

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
    cell.choiceButton.tag = indexPath.row
    cell.configCell(person) {[weak self] (index) in
      print(index)
      guard let strongSelf = self else { return }
      if strongSelf.memberArr[index].isAllSelected() {
        strongSelf.memberArr[index].unselectAll()
      } else {
        strongSelf.memberArr[index].selectAll()
      }
      cell.changeSelectedButtonImage()
    }
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
    var userids = [String]()
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChoseInvitationCell
    personUnderMemberVC.ensureClosure = {(a) -> Void in
      userids = a
      print(userids.count)
      if let count = member.member?.count {
        cell.amountLabel.text = "(\(userids.count)/\(count))"
      }
      
      self.memberArr[indexPath.row].selectMembers(a)
      
    }
    self.navigationController?.pushViewController(personUnderMemberVC, animated: true)
  }
    
}
