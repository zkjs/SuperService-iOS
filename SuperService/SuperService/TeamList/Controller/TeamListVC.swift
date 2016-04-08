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
  var sections = [String:[TeamModel]]()
  var teamArray = [TeamModel]() {
    didSet {
      /*let selector: Selector = "roledesc"
      sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
      let sortedObjects = collation.sortedArrayFromArray(teamArray, collationStringSelector: selector)
      for object in sortedObjects {
        let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
        sections[sectionNumber].append(object)
      }
      tableView.reloadData()*/
      
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
    loadData()
  }
  
  func loadData() {
    HttpService.sharedInstance.queryTeamsInfo { (teams, error) -> () in
      if let _ = error {
        
      } else {
        if let users = teams where users.count > 0 {
          self.teamArray.removeAll()
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
    //return sections[section].count
    let role = sectionTitleArr[section].1
    return sections[role]?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TeamListCell", forIndexPath: indexPath) as! TeamListCell
    
    let role = sectionTitleArr[indexPath.section].1
    if let team = sections[role]?[indexPath.row] {
      cell.setData(team) {[weak self] in
        if let strongSelf = self {
          let vc = EmployeeVC()
          vc.type = EmployeeVCType.team
          vc.employee = team
          vc.hidesBottomBarWhenPushed = true
          strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
      }
    }
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return TeamListCell.height()
  }
  
  
  // MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitleArr[section].1
  }
  
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    if (sections.count == 0){
      return nil
    }
    return sectionTitleArr.map{ $0.0 }
  }
  
  
//  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//    return collation.sectionForSectionIndexTitleAtIndex(index)
//  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let role = sectionTitleArr[indexPath.section].1
    guard let employee = sections[role]?[indexPath.row] else { return }
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
