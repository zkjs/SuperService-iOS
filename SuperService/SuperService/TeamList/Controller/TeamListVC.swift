//
//  TeamListVC.swift
//  SuperService
//
//  Created by Hanton on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit 

class TeamListVC: UIViewController, UITableViewDataSource, UITableViewDelegate,/*SWTableViewCellDelegate,*/ XLPagerTabStripChildItem {
  
  @IBOutlet weak var tableView: UITableView!
  
  let collation = UILocalizedIndexedCollation.currentCollation()
  var sections = [[AnyObject]]()
  var teamArray = [TeamModel]() {
    didSet {
      let selector: Selector = "roledesc"
      sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
      let sortedObjects = collation.sortedArrayFromArray(teamArray, collationStringSelector: selector)
      for object in sortedObjects {
        let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
        sections[sectionNumber].append(object)
      }
      tableView.reloadData()
    }
  }
  var titleArr = [String]()
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("TeamListVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "团队"
    let nibName = UINib(nibName: TeamListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: TeamListCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadData")  // 下拉刷新
    tableView.mj_header.beginRefreshing()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.mj_header.beginRefreshing()
    refresh()
  }
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "团队"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
  
  func refresh() {
    teamArray.removeAll()
    loadData()
  }
  
  func loadData() {
    HttpService.queryTeamsInfo { (teams, error) -> () in
      if let _ = error {
        
      } else {
        if let users = teams where users.count > 0 {
          self.teamArray = users
          self.tableView?.reloadData()
        }
      }
      self.tableView.mj_header.endRefreshing()

    }
  }
  
  // MARK: - Table View Data Source
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return sections.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TeamListCell", forIndexPath: indexPath) as! TeamListCell
    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("avatarTapped:"))
    cell.userImage.addGestureRecognizer(tapGestureRecognizer)
    cell.userImage.tag = indexPath.section*1000 + indexPath.row
    cell.userImage.userInteractionEnabled = true
    let section = sections[indexPath.section]
    let team = section[indexPath.row] as! TeamModel
    cell.setData(team)
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return TeamListCell.height()
  }
  
  
  // MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if (sections[section].count == 0){
      return nil
    }
    let selector: Selector = "roledesc"
    let sortedObjects = collation.sortedArrayFromArray(teamArray, collationStringSelector: selector)
    if section < sortedObjects.count - 1 {
      let model = sortedObjects[section] as! TeamModel 
      return model.roledesc
    } else {
      return nil
    }
    
  }
  
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    if (sections.count == 0){
      return nil
    }
    var titleArray = [String]()
    for (var i = 0 ; i < collation.sectionTitles.count-1; i++) {
      if (sections[i].count != 0){
        titleArray.append(collation.sectionTitles[i])
       }
    }
     titleArray.append(collation.sectionTitles[26])
    return titleArray
  }
  
  
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return collation.sectionForSectionIndexTitleAtIndex(index)
  }
  
  func avatarTapped(sender: UIGestureRecognizer) {
    guard let tag = sender.view?.tag else { return }
    let indexSection = tag/1000
    let indexRow = tag - indexSection*1000
    let vc = EmployeeVC()
    let section = sections[indexSection]
    let employee = section[indexRow] as! TeamModel
    vc.type = EmployeeVCType.team
    vc.employee = employee
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let section = sections[indexPath.section]
    let employee = section[indexPath.row] as! TeamModel
    var chatterName = ""
    guard let chatterID = employee.userid else { return }
    if let name = employee.username {
      chatterName = name
    }
    print(chatterID)
    let vc = ChatViewController(conversationChatter: chatterID, conversationType: .eConversationTypeChat)
    let userName = AccountInfoManager.sharedInstance.userName
    vc.title = chatterName
    vc.hidesBottomBarWhenPushed = true
    // 扩展字段
    let ext = ["toName": chatterName,
      "fromName": userName]
    vc.conversation.ext = ext
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
