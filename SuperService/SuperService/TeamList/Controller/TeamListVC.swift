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
  var selectedCellIndexPaths:[NSIndexPath] = []
  let collation = UILocalizedIndexedCollation.currentCollation()
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
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("TeamListVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "团队"
    let nibName = UINib(nibName: TeamListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: TeamListCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(TeamListVC.loadData))  // 下拉刷新
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
    HttpService.sharedInstance.queryTeamsInfo {[weak self] (teams, error) -> () in
      guard let strongSelf = self else {return}
      if let _ = error {
        
      } else {
        if let users = teams where users.count > 0 {
          strongSelf.teamArray.removeAll()
          strongSelf.teamArray = users
          strongSelf.tableView?.reloadData()
        }
      }
      strongSelf.tableView.mj_header.endRefreshing()

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
      "avatar":employee.avatarURL,
      "fromName": userName]
    vc.conversation.ext = ext
    navigationController?.pushViewController(vc, animated: true)
    
    self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    if let index = selectedCellIndexPaths.indexOf(indexPath) {
      selectedCellIndexPaths.removeAtIndex(index)
    }else{
      selectedCellIndexPaths.append(indexPath)
    }
    // Forces the table view to call heightForRowAtIndexPath
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // 要显示自定义的action,cell必须处于编辑状态
    return TokenPayload.sharedInstance.hasPermission(.DELEMPLOYEE)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    if !TokenPayload.sharedInstance.hasPermission(.DELEMPLOYEE) {
     return []
    } else {
      let more = UITableViewRowAction(style: .Normal, title: "删除") { action, index in
        //删除成员
        self.deleteTeamUser(indexPath)
      }
      more.backgroundColor = UIColor.redColor()
      return [more]
    }
    
  }
  
  func deleteTeamUser(indexPath:NSIndexPath) {
    self.showHudInView(view, hint: "")
    let role = sectionTitleArr[indexPath.section].1
    if let team = sections[role]?[indexPath.row],let userid = team.userid {
       HttpService.sharedInstance.deleteTeamUser(userid, completionHandler: { (json, error) in
        if let error = error {
          self.showErrorHint(error)
        } else {
          if let _ = json {
            self.sections[role]?.removeAtIndex(indexPath.row) 
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.tableView.reloadData() 
          }
        }
        self.hideHUD()
       })
    }
   
  }
}
