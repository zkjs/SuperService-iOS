//
//  PaymentListVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class PaymentListVC: UITableViewController {
  let pageSize = 20
  var paymentList = [PaymentListItem]()
  var currentPage = 0
  var nomoreData = false

  override func viewDidLoad() {
    self.title = "收款记录"
    
    loadData()
  }
  
  private func loadData() {
    if currentPage == 0 {
      showHUDInView(view, withLoading: "")
    }
    print("page:\(currentPage)")
    HttpService.getPaymentList(currentPage, pageSize: pageSize, status: nil) {[unowned self] (list, error) -> Void in
      self.hideHUD()
      if let error = error {
        self.showHint("\(error.code)")
      } else {
        if let list = list where list.count > 0 {
          self.paymentList += list
          self.tableView.reloadData()
          self.nomoreData = list.count < self.pageSize
        } else {
          self.showHint("没有收款记录")
          self.nomoreData = true
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
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == paymentList.count - 1 && !nomoreData {
      ++currentPage
      loadData()
    }
  }
}
