//
//  CallInfoVC.swift
//  SuperService
//
//  Created by AlexBang on 16/6/22.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class CallInfoVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
      super.viewDidLoad()
    title = "呼叫通知"
    let nibName = UINib(nibName: CallInfoCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CallInfoCell.reuseIdentifier())
    tableView.tableFooterView = UIView()

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("CallInfoVC", owner:self, options:nil)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 20
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CallInfoCell.height()
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CallInfoCell.reuseIdentifier(), forIndexPath: indexPath) as! CallInfoCell
    let firstRow = NSIndexPath(forRow: 0, inSection: 0)
    if indexPath == firstRow {
      cell.topLineImageView.hidden = true
    } else {
      cell.topLineImageView.hidden = false
    }
       return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = TasktrackingVC()
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
    
  }
    

}
