//
//  PaymentListVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class PaymentListVC: UITableViewController {
  var paymentList = [PaymentListItem]()

  override func viewDidLoad() {
    self.title = "收款记录"
    
    loadData()
  }
  
  private func loadData() {
    HttpService.getPaymentList(0, status: nil) {[unowned self] (list, error) -> Void in
      if let error = error {
        self.showHint("\(error.code)")
      } else {
        if let list = list where list.count > 0 {
          self.paymentList = list
          self.tableView.reloadData()
        } else {
          self.showHint("没有收款记录")
        }
      }
    }
  }
  
  //MARK: tableview data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return paymentList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PaymentListCell", forIndexPath: indexPath) as! PaymentListCell
    
    cell.configCell(paymentList[indexPath.row])
    
    return cell
  }
  
  
}
