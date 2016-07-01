//
//  PersonUnderMemberTVC.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class PersonUnderMemberTVC: UITableViewController {
  var titleString = ""
  var memberpersonArr = [MemberpersonModel]()
  //根据名字的首字母自动归类 使用UILocalizedIndexedCollation类
    let collation = UILocalizedIndexedCollation.currentCollation()
    var sections = [[AnyObject]]()
    var clientArray = [ClientModel]() {
        didSet {
            let selector: Selector = "username"
            sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
            
            let sortedObjects = collation.sortedArrayFromArray(clientArray, collationStringSelector: selector)
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memberpersonArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonunderMemberCell", forIndexPath: indexPath) as! PersonunderMemberCell
        let person = memberpersonArr[indexPath.row]
        cell.configCell(person)

        return cell
    }
    

    

}
