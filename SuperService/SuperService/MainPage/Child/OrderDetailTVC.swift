//
//  OrderDetailTVC.swift
//  SuperService
//
//  Created by admin on 15/10/27.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

private let kNameSection = 2
private let kReceiptSection = 4
private let kReceiptRow = 1
private let kRoomSection = 5
private let kRoomRow = 1
private let kServiceSection = 6
private let kServiceRow = 1

class OrderDetailTVC: UITableViewController,UITextFieldDelegate {
  
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var roomCountInfoLabel: UILabel!
  @IBOutlet weak var roomCountLabel: UILabel!
  @IBOutlet weak var dateInfoLabel: UILabel!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  @IBOutlet var nameInfos: [UILabel]!
  @IBOutlet weak var secondnameTextField: UITextField!
  @IBOutlet weak var secondnameLabel: UILabel!
  @IBOutlet var nameTextFields: [UITextField]!
  
  @IBOutlet weak var thirdnameLabel: UILabel!
  
  @IBOutlet weak var thirdnameTextField: UITextField!
  @IBOutlet weak var PaymentInfoLabel: UILabel!
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var paymentButton: UIButton!
  @IBOutlet weak var invoiceInfoLabel: UILabel!
  @IBOutlet weak var receiptLabel: UILabel!
  @IBOutlet weak var invoiceFooterLabel: UILabel!
  @IBOutlet weak var remarkInfoLabel: UILabel!
  @IBOutlet weak var remarkInfoPromptLabel: UILabel!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var roomTagInfoLabel: UILabel!
  @IBOutlet weak var roomTagView: JCTagListView!
  @IBOutlet weak var roomTagFooterLabel: UILabel!
  @IBOutlet weak var serviceInfoLabel: UILabel!
  @IBOutlet weak var serviceTagView: JCTagListView!
  @IBOutlet weak var serviceFooterLabel: UILabel!
  
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  var reservationNO: String!
  var order: OrderModel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "订单处理"
    loadData()
  }
  
  
  func setupOrder() {
  
  }
  
  func loadData() {
    ZKJSHTTPSessionManager.sharedInstance().getOrderWithReservationNO(reservationNO, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      
      self.setupOrder()
      
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return super.tableView(tableView, numberOfRowsInSection: section)
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}
