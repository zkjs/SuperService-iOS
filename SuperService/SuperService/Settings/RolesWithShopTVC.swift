//
//  RolesWithShopTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class RolesWithShopTVC: UITableViewController {
  var selectedRolesArray = [String]()
  var selectedArray = [Int]()
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
    let selectServiceAreaVC = storyboard.instantiateViewControllerWithIdentifier("SelectServiceAreaTVC") as! SelectServiceAreaTVC
    selectServiceAreaVC.selectedRolesArr = selectedRolesArray
    guard let str = clubtextField.text else {
      self.showHint("请填写标签")
      return
    }
    selectServiceAreaVC.firstSrvTagName = str
    navigationController?.pushViewController(selectServiceAreaVC, animated: true)
  }
  
  func loadData() {
    self.selectedRolesArray.removeAll()
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
          strongSelf.initSelectedArray()
        }
      }
    }
    
  }
  
  func initSelectedArray() {
    for index in 0..<sections.count {
      let role = sectionTitleArr[index].1
        for row in 0..<sections[role]!.count {
          let team = sections[role]?[row]
          if selectedRolesArray.contains((team?.userid!)!) {
            let a = index + row
            selectedArray.append(a)
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
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! RolesWithShopCell
    cell.changeSelectedButtonImage()
    updateSelectedArrayWithCell(cell,section: indexPath.section,row: indexPath.row)
  }
  
  
  func updateSelectedArrayWithCell(cell: RolesWithShopCell,section:Int,row:Int) {
    let role = sectionTitleArr[section].1
    guard let team = sections[role]?[row] else {return}
    if cell.isUncheck == false {
      self.selectedArray.append(section + row)
      selectedRolesArray.append(team.userid!)
      print(selectedRolesArray)
    } else {
      if let index = selectedArray.indexOf(section + row) {
        selectedArray.removeAtIndex(index)
        for (index, value) in selectedRolesArray.enumerate() {
          if selectedRolesArray.count == 1 {
            selectedRolesArray.removeAtIndex(0)
            return
          }
          if case team.userid! = value {
            selectedRolesArray.removeAtIndex(index)
            print(selectedRolesArray)
            print("Found \(value) at position \(index)")
            return
          }
        }
      }
    }
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitleArr[section].1
  }
    

}
