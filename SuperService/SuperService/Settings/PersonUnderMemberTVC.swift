//
//  PersonUnderMemberTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
typealias EnsureInvitationPersonClosure = (userids:[String]) -> Void
class PersonUnderMemberTVC: UITableViewController {
  var titleString = ""
  var checkUserids = [String]()
  var ensureClosure:EnsureInvitationPersonClosure?
  
  //根据名字的首字母自动归类 使用UILocalizedIndexedCollation类
    let collation = UILocalizedIndexedCollation.currentCollation()
    var sections = [[AnyObject]]()
    var memberpersonArr = [MemberpersonModel]() {
        didSet {
            let selector: Selector = Selector("username")
            sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
            let sortedObjects = collation.sortedArrayFromArray(memberpersonArr, collationStringSelector: selector)
            for object in sortedObjects {
              let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
              sections[sectionNumber].append(object)
           }
            
            self.tableView.reloadData()
          }
      }
  override func viewDidLoad() {
      super.viewDidLoad()
    title = titleString
    tableView.tableFooterView = UIView()
    let nextStepButton = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonUnderMemberTVC.ensure))
    navigationItem.rightBarButtonItem = nextStepButton

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  func ensure(sender:UIBarButtonItem) {
    self.navigationController?.popViewControllerAnimated(true)
    if let closure = self.ensureClosure {
      closure(userids: self.checkUserids)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    for p in memberpersonArr {
      self.checkUserids.append(p.userid)
    }
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return sections.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return sections[section].count
  }

  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("PersonunderMemberCell", forIndexPath: indexPath) as! PersonunderMemberCell
      let section = sections[indexPath.section]
      let person = section[indexPath.row] as! MemberpersonModel
        cell.configCell(person)
      return cell
  }
    

  override func tableView(tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
     if (sections[section].count == 0){
            return nil
      }
      return collation.sectionTitles[section]
  }
  
  override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    if (sections.count == 0) {
      return nil
    }
    var titleArray = [String]()
    for i in 0..<collation.sectionTitles.count {
      if (sections[i].count != 0) {
        titleArray.append(collation.sectionTitles[i])
      }
    } 
    titleArray.append((collation.sectionTitles[26]))
    return titleArray
  }
  
  override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return collation.sectionForSectionIndexTitleAtIndex(index)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! PersonunderMemberCell
    cell.changeSelectedButtonImage()
    let section = sections[indexPath.section]
    let person = section[indexPath.row] as! MemberpersonModel
    if cell.isUncheck == true {
      for (index, value) in checkUserids.enumerate() {
        if checkUserids.count == 1 {
          checkUserids.removeAtIndex(0)
          return
        }
        if person.userid == value {
          checkUserids.removeAtIndex(index)
        }
      }
    } else {
      checkUserids.append(person.userid)
    }
    print(checkUserids.count)
  } 
  
}		


