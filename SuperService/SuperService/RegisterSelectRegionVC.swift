//
//  RegisterSelectRegionVC.swift
//  SuperService
//
//  Created by Hanton on 9/30/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class RegisterSelectRegionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  // MARK: - Table View Data Source
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  // MARK: - Table View Delegate
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SelectRegionCell.reuseIdentifier())
    guard let tableCell = cell else {
      return UITableViewCell()
    }
    return tableCell
  }
  
  
  // MARK: - Button Action
  
  @IBAction func goBack(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
}
