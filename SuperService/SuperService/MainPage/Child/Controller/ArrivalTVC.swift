//
//  ArrivalTVC.swift
//  SuperService
//
//  Created by Hanton on 10/8/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class ArrivalTVC: UITableViewController, XLPagerTabStripChildItem {
  
  var dataArray: [ClientArrivalInfo]?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: ArrivalCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: ArrivalCell.reuseIdentifier())
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    refresh()
  }
  
  
  // MARK: - Public
  
  func refresh() {
    loadData()
    tableView.reloadData()
  }
  
  
  // MARK: - Private
  
  func loadData() {
    dataArray = Persistence.sharedInstance().fetchClientArrivalInfoArray()
    print(dataArray?.count)
  }
  
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "到店通知"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let data = dataArray else { return 0}
    return data.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ArrivalCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(ArrivalCell.reuseIdentifier(), forIndexPath: indexPath) as! ArrivalCell

    let firstRow = NSIndexPath(forRow: 0, inSection: 0)
    if indexPath == firstRow {
      cell.topLineImageView.hidden = true
    } else {
      cell.topLineImageView.hidden = false
    }
    
    let data = dataArray![indexPath.row]
    cell.setData(data)
    
    return cell
  }
  
}
