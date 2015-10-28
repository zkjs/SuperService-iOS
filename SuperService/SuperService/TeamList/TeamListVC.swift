//
//  TeamListVC.swift
//  SuperService
//
//  Created by Hanton on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class TeamListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
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
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return collation.sectionForSectionIndexTitleAtIndex(index)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}
