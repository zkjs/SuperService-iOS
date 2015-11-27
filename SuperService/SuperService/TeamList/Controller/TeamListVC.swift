//
//  TeamListVC.swift
//  SuperService
//
//  Created by Hanton on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class TeamListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, RefreshTeamListVCDelegate,/*SWTableViewCellDelegate,*/ XLPagerTabStripChildItem {
  
  @IBOutlet weak var tableView: UITableView!
  
  let collation = UILocalizedIndexedCollation.currentCollation()
  var sections = [[AnyObject]]()
  var teamArray = [TeamModel]() {
    didSet {
      let selector: Selector = "name"
      sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
      
      let sortedObjects = collation.sortedArrayFromArray(teamArray, collationStringSelector: selector)
      for object in sortedObjects {
        let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
        sections[sectionNumber].append(object)
      }
      self.tableView.reloadData()

    }
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("TeamListVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "团队"
    
    loadData()
    
    let nibName = UINib(nibName: TeamListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: TeamListCell.reuseIdentifier())
    
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let isAdmin = AccountManager.sharedInstance().isAdmin()
    if isAdmin {
      // 管理员才能添加员工
      let addMemberButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "AddMember")
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let baseNC = appDelegate.mainTBC.selectedViewController as! BaseNavigationController
      baseNC.topViewController?.navigationItem.rightBarButtonItem = addMemberButton
    }
    
    RefreshTeamListTableView()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    let isAdmin = AccountManager.sharedInstance().isAdmin()
    if isAdmin {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let baseNC = appDelegate.mainTBC.selectedViewController as! BaseNavigationController
      baseNC.topViewController?.navigationItem.rightBarButtonItem = nil
    }
  }
  
  // MARK: - Public
  
  func AddMember() {
    let vc = AddMemberVC()
    vc.delegate = self
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "团队"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
  
  //RefreshTeamListVCDelegate
  
  func RefreshTeamListTableView() {
    teamArray.removeAll()
    loadData()
  }
  
  func loadData() {
    ZKJSHTTPSessionManager.sharedInstance().getTeamListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? NSArray {
        var datasource = [TeamModel]()
        for dic in array {
          let team = TeamModel(dic: dic as! [String:AnyObject])
          datasource.append(team)  
        }        
        self.teamArray = datasource      
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
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
    return collation.sectionTitles[section]
  }
  
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    if (sections.count == 0){
      return nil
    }
    
    var titleArray = [String]()
    
    for (var i = 0 ; i < collation.sectionTitles.count; i++) {
      if (sections[i].count != 0){
        titleArray.append(collation.sectionTitles[i])
        
      }
    }
    
    titleArray.append(collation.sectionTitles[26])
    return titleArray
    
  }
  
  
//  //MARK - SWTabelViewDelagate
//  func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
//    switch index {
//    case 0:
//      let indexPath = tableView.indexPathForCell(cell)!
//      let team = teamArray[indexPath.row]
//      
//      teamArray.removeAtIndex(indexPath.row)
//      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//      ZKJSHTTPSessionManager.sharedInstance().deleteMemberWithDeleteList(team.salesid, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
//        
//        }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
//          
//      })
//    default:
//      break
//    }
//  }
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return collation.sectionForSectionIndexTitleAtIndex(index)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = EmployeeVC()
    let section = sections[indexPath.section]
    let employee = section[indexPath.row] as! TeamModel
    vc.type = EmployeeVCType.team
    vc.employee = employee
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
