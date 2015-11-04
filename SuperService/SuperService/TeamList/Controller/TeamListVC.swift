//
//  TeamListVC.swift
//  SuperService
//
//  Created by Hanton on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class TeamListVC: UIViewController, UITableViewDataSource, UITableViewDelegate ,RefreshTeamListVCDelegate,SWTableViewCellDelegate{
  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "团队"
    
    loadData()
    ZKJSTool.showLoading("正在加载")
    ZKJSTool.hideHUD()
    
    let nibName = UINib(nibName: TeamListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: TeamListCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    let  add_clientButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: "AddMemberBtn:")
    
    self.navigationItem.rightBarButtonItem = add_clientButton
  
  }
  
  func AddMemberBtn(sender: UIButton) {
    let vc = AddMemberVC()
    vc.delegate = self
    self.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
    self.hidesBottomBarWhenPushed = false
  
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //RefreshTeamListVCDelegate
  func RefreshTeamListTableView(set: [String : AnyObject],memberModel:TeamModel) {
    let member = memberModel
    self.teamArray.append(member)
    self.tableView.reloadData()
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
  
  
  //MARK - SWTabelViewDelagate
  func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
    switch index {
    case 0:
      let indexPath = tableView.indexPathForCell(cell)!
      let team = teamArray[indexPath.row]
      
      teamArray.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
      ZKJSHTTPSessionManager.sharedInstance().deleteMemberWithDeleteList(team.salesid, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        
        }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      })
    default:
      break
    }
  }
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return collation.sectionForSectionIndexTitleAtIndex(index)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}
