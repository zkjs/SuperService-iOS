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

class OrderDetailTVC: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var dateInfoLabel: UILabel!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  @IBOutlet weak var roomTypeLabel: UILabel!
  @IBOutlet weak var roomCountLabel: UILabel!
  @IBOutlet weak var paymentTypeLabel: UILabel!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var invoiceTextField: UITextField!
  @IBOutlet var nameTextFields: [UITextField]!
  @IBOutlet weak var roomTagView: JCTagListView!
  @IBOutlet weak var serviceTagView: JCTagListView!
  @IBOutlet weak var remarkTextView: UITextView!
  
  var reservationNO: String!
  var order: OrderModel!
  var paymentArray = [PaymentModel]()
  var goodsArray = [GoodsModel]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "订单处理"
    loadData()
  }
  
  
  func setupOrder() {
    startDateLabel.text = order.arrivalDateShortStyle!
    endDateLabel.text = order.departureDateShortStyle!
    dateInfoLabel.text = "共\(order.duration!.stringValue)晚 在\(order.departureDateShortStyle!) 13点前退房"
    roomTypeLabel.text = order.room_type!
    roomCountLabel.text = order.rooms!.stringValue
    paymentTypeLabel.text = order.pay_name!
    amountTextField.text = order.room_rate!.stringValue
//    invoiceTextField.text = order.
//    nameTextFields
//    roomTagView
//    serviceTagView
//    remarkTextView.text = order.remar
  }
  
  func loadData() {
    ZKJSTool.showLoading("正在加载数据...")
    ZKJSHTTPSessionManager.sharedInstance().getOrderWithReservationNO(reservationNO, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let dict = responseObject as? [String: AnyObject] {
        if let room = dict["room"] as? [String: AnyObject] {
          self.order = OrderModel(dic: room)
        }
        
        if let invoice = dict["invoice"] as? String {
          print(invoice)
        }
        
        if let privilege = dict["privilege"] as? String {
          print(privilege)
        }
        
        if let room_tag = dict["room_tag"] as? String {
          print(room_tag)
        }
        
        if let users = dict["users"] as? String {
          print(users)
        }
      }
      self.setupOrder()
      ZKJSTool.hideHUD()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
    
    // 获取支付方式
    ZKJSHTTPSessionManager.sharedInstance().getPaymentListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? [[String: AnyObject]] {
        for dict in array {
          let payment = PaymentModel(dic: dict)
          self.paymentArray.append(payment)
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
    
    // 获取房型列表
    ZKJSHTTPSessionManager.sharedInstance().getGoodsListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? [[String: AnyObject]] {
        for dict in array {
          let goods = GoodsModel(dic: dict)
          self.goodsArray.append(goods)
        }
      }
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
    
    if indexPath == NSIndexPath(forRow: 2, inSection: 0) {  // 入住/离店时间
      chooseDate()
    } else if indexPath == NSIndexPath(forRow: 0, inSection: 1) {  // 房间类型
      chooseRoomType()
    } else if indexPath == NSIndexPath(forRow: 1, inSection: 1) {  // 房间数量
      chooseRoomCount()
    } else if indexPath == NSIndexPath(forRow: 0, inSection: 2) {  // 支付方式
      choosePayment()
    }
  }
  
  func chooseDate() {
    let vc = BookDateSelectionViewController()
    vc.selection = { [unowned self] (startDate: NSDate, endDate: NSDate) ->() in
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "M/dd"
      self.startDateLabel.text = dateFormatter.stringFromDate(startDate)
      self.endDateLabel.text = dateFormatter.stringFromDate(endDate)
      let duration = NSDate.daysFromDate(startDate, toDate: endDate)
      self.dateInfoLabel.text = "共\(duration)晚 在\(self.endDateLabel.text!) 13点前退房"
      // 更新订单
      dateFormatter.dateFormat = "yyyy-MM-dd"
      self.order.arrival_date = dateFormatter.stringFromDate(startDate)
      self.order.departure_date = dateFormatter.stringFromDate(endDate)
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func chooseRoomType() {
    let alertView = UIAlertController(title: "选择房型", message: "", preferredStyle: .ActionSheet)
    for room in goodsArray {
      alertView.addAction(UIAlertAction(title: room.name!, style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.roomTypeLabel.text = room.name!
        // 更新订单
        self.order.room_typeid = room.id
        self.order.room_type = room.name
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseRoomCount() {
    let alertView = UIAlertController(title: "选择房间数", message: "", preferredStyle: .ActionSheet)
    for i in 1...3 {
      alertView.addAction(UIAlertAction(title: "\(i)间", style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.roomCountLabel.text = "\(i)"
        // 更新订单
        self.order.rooms = NSNumber(integer: i)
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func choosePayment() {
    let alertView = UIAlertController(title: "选择支付方式", message: "", preferredStyle: .ActionSheet)
    for payment in paymentArray {
      alertView.addAction(UIAlertAction(title: payment.pay_name!, style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.paymentTypeLabel.text = payment.pay_name!
        // 更新订单
        self.order.pay_id = payment.pay_id
        self.order.pay_name = payment.pay_name
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  @IBAction func updateOrder(sender: AnyObject) {
    if let amountText = amountTextField.text {
      if let amount = Int(amountText) {
        order.room_rate = NSNumber(integer: amount)
      } else {
        order.room_rate = NSNumber(integer: 0)
      }
    } else {
      order.room_rate = NSNumber(integer: 0)
    }
    print(order)
    ZKJSTool.showLoading("正在更新订单...")
    ZKJSHTTPSessionManager.sharedInstance().updateOrderWithOrder(order, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      ZKJSTool.hideHUD()
      self.navigationController?.popViewControllerAnimated(true)
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
}
