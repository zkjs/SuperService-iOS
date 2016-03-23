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
  var payResult: FacePayResult?
  override func viewDidLoad() {
    self.title = "收款记录"
    
    loadData()
    self.tableView.tableFooterView = UIView()
  }
  
  private func loadData() {
    if currentPage == 0 {
      showHUDInView(view, withLoading: "")
    }
    print("page:\(currentPage)")
    HttpService.getPaymentList(currentPage, pageSize: pageSize, status: nil) {[weak self] (list, error) -> Void in
      guard let strongSelf = self else { return }
      strongSelf.hideHUD()
      if let error = error {
        strongSelf.showHint("\(error.code)")
      } else {
        if let list = list where list.count > 0 {
          strongSelf.paymentList += list
          strongSelf.tableView.reloadData()
          strongSelf.nomoreData = list.count < strongSelf.pageSize
        } else {
          strongSelf.showHint("没有收款记录")
          strongSelf.nomoreData = true
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
    let pay = paymentList[indexPath.row] 
    self.payResult = FacePayResult(customer:pay.custom, amount: pay.amount/100, succ: pay.status, orderNo: pay.orderno, errorCode: 0, waiting: pay.amount > 100,confirmTime:pay.confirmtime,createTime:pay.createtime)
    self.performSegueWithIdentifier("checkPayInfoSegue", sender:nil)
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == paymentList.count - 1 && !nomoreData {
      ++currentPage
      loadData()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "checkPayInfoSegue" {
      let vc = segue.destinationViewController as! PaymentResultVC
      vc.payResult = payResult
      vc.type = pushType.PaymentList
    }
  }
}
