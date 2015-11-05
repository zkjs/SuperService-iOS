//
//  OrderDetailTVC.swift
//  SuperService
//
//  Created by admin on 15/10/27.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit


enum OrderType: Int {
  case Add = 0
  case Update = 1
}

class OrderDetailTVC: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var dateInfoTextField: UITextField!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  @IBOutlet weak var roomTypeTextField: UITextField!
  @IBOutlet weak var roomCountTextField: UITextField!
  @IBOutlet weak var paymentTextField: UITextField!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var invoiceTextField: UITextField!
  @IBOutlet var nameTextFields: [UITextField]!
  @IBOutlet weak var roomTagView: JCTagListView!
  @IBOutlet weak var serviceTagView: JCTagListView!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var clientNameTextField: UITextField!
  @IBOutlet weak var orderStatusTextField: UITextField!
  
  var type = OrderType.Add
  var reservationNO: String!
  var order = OrderModel()
  var paymentArray = [PaymentModel]()
  var goodsArray = [GoodsModel]()
  var orderStatusArray = ["待确定", "已取消", "已确定", "已完成", "入住中", "已删除"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "订单处理"
    loadData()
  }
  
  
  func setupOrder() {
    startDateLabel.text = order.arrivalDateShortStyle
    endDateLabel.text = order.departureDateShortStyle
    
    if let duration = order.duration, let departureDate = order.departureDateShortStyle {
      dateInfoTextField.text = "共\(duration.stringValue)晚 在\(departureDate) 13点前退房"
    }
    
    roomTypeTextField.text = order.room_type
    
    if let rooms = order.rooms {
      roomCountTextField.text = rooms.stringValue
    } else {
      roomCountTextField.text = ""
    }
    
    paymentTextField.text = order.pay_name
    
    if let room_rate = order.room_rate {
      amountTextField.text = room_rate.stringValue
    } else {
      amountTextField.text = ""
      order.room_rate = NSNumber(integer: 0)
    }
    amountTextField.delegate = self
    
    clientNameTextField.text = order.guest
    orderStatusTextField.text = order.orderStatus
    
    //    invoiceTextField.text = order.
    //    nameTextFields
    //    roomTagView
    //    serviceTagView
    //    remarkTextView.text = order.remar
  }
  
  func loadData() {
    if type == .Update {
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
    } else if type == .Add {
      setupOrder()
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
    } else if indexPath == NSIndexPath(forRow: 0, inSection: 3) {  // 预定人
      if type == .Update {
        // 如果是更新订单，则不能修改预定人
        return
      }
      chooseClient()
    } else if indexPath == NSIndexPath(forRow: 1, inSection: 3) {  // 订单状态
      chooseOrderStatus()
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
      self.dateInfoTextField.text = "共\(duration)晚 在\(self.endDateLabel.text!) 13点前退房"
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
        self.roomTypeTextField.text = room.name!
        // 更新订单
        self.order.room_typeid = room.id
        self.order.room_type = room.name
        self.order.imgurl = room.imgurl
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseRoomCount() {
    let alertView = UIAlertController(title: "选择房间数", message: "", preferredStyle: .ActionSheet)
    for i in 1...3 {
      alertView.addAction(UIAlertAction(title: "\(i)间", style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.roomCountTextField.text = "\(i)"
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
        self.paymentTextField.text = payment.pay_name!
        // 更新订单
        self.order.pay_id = payment.pay_id
        self.order.pay_name = payment.pay_name
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseOrderStatus() {
    let alertView = UIAlertController(title: "选择订单状态", message: "", preferredStyle: .ActionSheet)
    
    for index in 0..<orderStatusArray.count {
      alertView.addAction(UIAlertAction(title: orderStatusArray[index], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.orderStatusTextField.text = self.orderStatusArray[index]
        // 更新订单
        self.order.status = NSNumber(integer: index)
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseClient() {
    let vc = ClientListVC()
    vc.selection = { [unowned self] (client: ClientModel) ->() in
      self.clientNameTextField.text = client.username
      // 更新订单
      self.order.userid = client.userid
      self.order.guest = client.username
      self.order.guesttel = client.phone
    }
    navigationController?.pushViewController(vc, animated: true)
    
//    testChooseClient()
  }
  
  func testChooseClient() {
    let clientArray = [["userid": "5603d8d417392", "guest": "Hanton", "guesttel": "18925232944"],
      ["userid": "5555ee0c86e4c", "guest": "AlexBang", "guesttel": "15815507102"]]
    let alertView = UIAlertController(title: "选择订单状态-只供测试", message: "", preferredStyle: .ActionSheet)
    
    for index in 0..<clientArray.count {
      let client = clientArray[index]
      alertView.addAction(UIAlertAction(title: client["guest"], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.clientNameTextField.text = client["guest"]
        // 更新订单
        self.order.userid = client["userid"]
        self.order.guest = client["guest"]
        self.order.guesttel = client["guesttel"]
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  @IBAction func doneOrder(sender: AnyObject) {
    if checkOrder() == false {
      return
    }
    
    print(order)
    
    switch type {
    case .Add:
      addOrder()
    case .Update:
      updateOrder()
    }
  }
  
  func checkOrder() -> Bool {
    var showAlert = false
    var alertContent = ""
    if dateInfoTextField.text!.isEmpty {
      showAlert = true
      alertContent = "入住/离店日期"
    } else if roomTypeTextField.text!.isEmpty {
      showAlert = true
      alertContent = "房型"
    } else if roomCountTextField.text!.isEmpty {
      showAlert = true
      alertContent = "房间数量"
    } else if paymentTextField.text!.isEmpty {
      showAlert = true
      alertContent = "支付方式"
    } else if amountTextField.text!.isEmpty {
      showAlert = true
      alertContent = "支付金额"
    } else if clientNameTextField.text!.isEmpty {
      showAlert = true
      alertContent = "预定人"
    } else if orderStatusTextField.text!.isEmpty {
      showAlert = true
      alertContent = "订单状态"
    }
    
    if showAlert {
      let alertView = UIAlertController(title: "\(alertContent)不能为空", message: "", preferredStyle: .Alert)
      alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
      presentViewController(alertView, animated: true, completion: nil)
      return false
    } else {
      return true
    }
  }
  
  func addOrder() {
    ZKJSTool.showLoading("正在新增订单...")
    ZKJSHTTPSessionManager.sharedInstance().addOrderWithOrder(order, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      ZKJSTool.hideHUD()
      self.navigationController?.popViewControllerAnimated(true)
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  func updateOrder() {
    ZKJSTool.showLoading("正在更新订单...")
    ZKJSHTTPSessionManager.sharedInstance().updateOrderWithOrder(order, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      ZKJSTool.hideHUD()
      self.navigationController?.popViewControllerAnimated(true)
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  
  // MARK: - UITextFieldDelegate
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == amountTextField {
      if let amountText = amountTextField.text {
        if let amount = Double(amountText) {
          order.room_rate = NSNumber(double: amount)
        } else {
          order.room_rate = NSNumber(double: 0)
        }
      } else {
        order.room_rate = NSNumber(double: 0)
      }
    }
  }
  
}
