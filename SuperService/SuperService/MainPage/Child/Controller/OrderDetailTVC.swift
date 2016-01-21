//
//  OrderDetailTVC.swift
//  SuperService
//
//  Created by admin on 15/10/27.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit


@objc enum OrderType: Int {
  case Add
  case Update
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
  
  lazy var type = OrderType.Add
  var reservationNO: String!
  lazy var order = OrderModel()
  lazy var paymentArray = [PaymentModel]()
  lazy var goodsArray = [GoodsModel]()
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
//    roomTypeTextField.text = order.room_type
//    if let rooms = order.rooms {
//      roomCountTextField.text = rooms.stringValue
//    } else {
//      roomCountTextField.text = ""
//    }
//    paymentTextField.text = order.pay_name
//    if let room_rate = order.room_rate {
//      amountTextField.text = room_rate.stringValue
//    } else {
//      amountTextField.text = ""
//      order.room_rate = NSNumber(integer: 0)
//    }
//    amountTextField.delegate = self
//    clientNameTextField.text = order.guest
//    orderStatusTextField.text = order.orderStatus
//    invoiceTextField.text = order.reservation_no

  }
  
  func loadData() {
    if type == .Update {
      showHUDInView(view, withLoading: "正在加载数据...")
      ZKJSHTTPSessionManager.sharedInstance().getOrderWithReservationNO(reservationNO, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        if let dict = responseObject as? [String: AnyObject] {
          if let room = dict["room"] as? [String: AnyObject] {
            self.order = OrderModel(dic: room)
            self.remarkTextView.text = self.order.remark  ?? ""
          }
          if let invoice = dict["invoice"] as? String {
            self.invoiceTextField.text = invoice
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
        self.hideHUD()
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
      //chooseOrderStatus()
    }
}
  
  func chooseDate() {
    let vc = BookDateSelectionViewController()
    vc.selection = { [unowned self] (startDate: NSDate, endDate: NSDate) ->() in
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "M/dd"
      self.startDateLabel.text = dateFormatter.stringFromDate(startDate)
      self.endDateLabel.text = dateFormatter.stringFromDate(endDate)
      let duration = NSDate.ZKJS_daysFromDate(startDate, toDate: endDate)
      self.dateInfoTextField.text = "共\(duration)晚 在\(self.endDateLabel.text!) 13点前退房"
      // 更新订单
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//      self.order.arrival_date = dateFormatter.stringFromDate(startDate)
//      self.order.departure_date = dateFormatter.stringFromDate(endDate)
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func chooseRoomType() {
    let alertView = UIAlertController(title: "选择房型", message: "", preferredStyle: .ActionSheet)
    for room in goodsArray {
      alertView.addAction(UIAlertAction(title: room.name!, style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.roomTypeTextField.text = room.name!
        // 更新订单
//        self.order.room_typeid = room.id
//        self.order.room_type = room.name
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
//        self.order.rooms = NSNumber(integer: i)
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
//        self.order.pay_id = payment.pay_id
//        self.order.pay_name = payment.pay_name
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
//        self.order.status = NSNumber(integer: index)
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseClient() {
    let vc = ClientListVC()
    vc.type = ClientListVCType.order
    vc.selection = { [unowned self] (client: ClientModel) ->() in
      self.clientNameTextField.text = client.username
      // 更新订单
      self.order.userid = client.userid
//      self.order.guest = client.username
//      self.order.guesttel = client.phone
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func doneOrder(sender: AnyObject) {
    if checkOrder() == false {
      return
    }
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
    showHUDInView(view, withLoading: "正在新增订单...")
    ZKJSHTTPSessionManager.sharedInstance().addOrderWithOrder(order, success: { [unowned self] (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      self.hideHUD()
      // 发送环信透传消息
      if let orderNO = responseObject["reservation_no"] as? String {
        self.sendNewOrderNotificationToClientWithOrderNO(orderNO)
      }
      self.navigationController?.popViewControllerAnimated(true)
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  func sendNewOrderNotificationToClientWithOrderNO(orderNO: String) {
    let shopID = AccountManager.sharedInstance().shopID
    if let clientID = order.userid {
      let cmdChat = EMChatCommand()
      cmdChat.cmd = "sureOrder"
      let body = EMCommandMessageBody(chatObject: cmdChat)
      let message = EMMessage(receiver: clientID, bodies: [body])
      message.ext = ["shopId": shopID,
                     "orderNo": orderNO]
      message.messageType = .eMessageTypeChat
      EaseMob.sharedInstance().chatManager.asyncSendMessage(message, progress: nil)
    }
  }
  
  func updateOrder() {
    showHUDInView(view, withLoading: "正在更新订单...")
    ZKJSHTTPSessionManager.sharedInstance().updateOrderWithOrder(order, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      self.hideHUD()
      self.navigationController?.popViewControllerAnimated(true)
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  
  // MARK: - UITextFieldDelegate
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == amountTextField {
//      if let amountText = amountTextField.text {
//        if let amount = Double(amountText) {
//          order.room_rate = NSNumber(double: amount)
//        } else {
//          order.room_rate = NSNumber(double: 0)
//        }
//      } else {
//        order.room_rate = NSNumber(double: 0)
//      }
    }
  }
  
}
