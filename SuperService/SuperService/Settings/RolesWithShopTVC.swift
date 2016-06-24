//
//  RolesWithShopTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class RolesWithShopTVC: UITableViewController {
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
  @IBOutlet weak var clubtextField: UITextField!
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "新建服务标签"
    
    let rightbarItem = UIBarButtonItem.init(title: "下一步", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RolesWithShopTVC.nextStep))
    navigationItem.rightBarButtonItem = rightbarItem
    let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item
    tableView.tableFooterView = UIView()

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  } 

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()

  }
  
  func nextStep() {
    let storyboard = UIStoryboard(name: "ServicelabelVC", bundle: nil)
    let rolesWithShopVC = storyboard.instantiateViewControllerWithIdentifier("SelectServiceAreaTVC") as! SelectServiceAreaTVC
    navigationController?.pushViewController(rolesWithShopVC, animated: true)
  }
  
  func loadData() {

    self.showHudInView(view, hint: "")
    HttpService.sharedInstance.queryTeamsInfo {[weak self] (teams, error) -> () in
      guard let strongSelf = self else {return}
      if let error = error {
        self?.showErrorHint(error)
        self?.hideHUD()
      } else {
        if let users = teams where users.count > 0 {
          strongSelf.teamArray.removeAll()
          strongSelf.teamArray = users
          strongSelf.tableView?.reloadData()
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
      let cell = tableView.dequeueReusableCellWithIdentifier("RolesWithShopCell", forIndexPath: indexPath) as! RolesWithShopCell
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
    

}
