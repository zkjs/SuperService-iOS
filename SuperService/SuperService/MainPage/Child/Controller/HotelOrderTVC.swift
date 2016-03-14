//
//  HotelOrderTVC.swift
//  SVIP
//
//  Created by AlexBang on 15/12/29.
//  Copyright © 2015年 zkjinshi. All rights reserved.
//

import UIKit


@objc enum HotelOrderType: Int {
  case Add
  case Update
}


class HotelOrderTVC: UITableViewController,UITextFieldDelegate {

  @IBOutlet weak var invoiceLabel: UILabel!
  @IBOutlet weak var privilageLabel: UILabel!
  @IBOutlet weak var orderNoLabel: UILabel!
  @IBOutlet weak var daysLabel: UILabel!
  @IBOutlet weak var roomsTypeLabel: UILabel!
  @IBOutlet weak var roomsTextField: UITextField!
  @IBOutlet weak var contactTextField: UITextField!
  @IBOutlet weak var telphoneTextField: UITextField!
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var breakfeastSwitch: UISwitch!
  @IBOutlet weak var isSmokingSwitch: UISwitch!
  @IBOutlet weak var remarkTextView: UITextView!
  @IBOutlet weak var countSubtractButton: UIButton! {
    didSet {
      countSubtractButton.addTarget(self, action: "countSubtract:", forControlEvents: UIControlEvents.TouchUpInside)
      countSubtractButton.layer.borderWidth = 1
      countSubtractButton.layer.borderColor = UIColor.ZKJS_lineColor().CGColor
    }
  }
  @IBOutlet weak var countAddButton: UIButton! {
    didSet {
      countAddButton.addTarget(self, action: "countAdd:", forControlEvents: UIControlEvents.TouchUpInside)
      countAddButton.layer.borderWidth = 1
      countAddButton.layer.borderColor = UIColor.ZKJS_lineColor().CGColor
    }
  }
  @IBOutlet weak var invoiceTextField: UITextField!
  @IBOutlet weak var clientLabel: UILabel!
  @IBOutlet weak var amountTextField: UITextField!

  var shopName: String!
  var saleid: String!
  var roomsCount = 1
  var leavedate:String!
  var arrivaldate: String!
  var type = HotelOrderType.Update
  var orderno:String!
  var order = OrderModel()
  var paytypeArray = ["未设置", "在线支付", "到店支付", "挂帐"]
  var startDate: NSDate?
  var endDate: NSDate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = shopName
  tableView.bounces = false
    if type == .Update {
      loadData()
    } else if type == .Add {
      setUpUI()
    }
    
    print(order)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
  }
  
  func loadData() {
    showHUDInView(view, withLoading: "")
    ZKJSJavaHTTPSessionManager.sharedInstance().getOrderDetailWithOrderNo(orderno, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let data = responseObject as? [String: AnyObject] {
        self.order = OrderModel(dic: data)
        self.setUpUI()
      }
      self.hideHUD()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
      self.hideHUD()
    }
  }
  
  func countAdd(sender: AnyObject) {
    self.countSubtractButton.enabled = true
    roomsCount++
    self.roomsTextField.text = String(roomsCount)
  }
  func countSubtract(sender: AnyObject) {
    
    if roomsCount < 2 {
      self.countSubtractButton.enabled = false
      return
    }
    roomsCount--
    self.roomsTextField.text = String(roomsCount)
  }
  
  func setUpUI() {
    if let _ = order.orderno {
//      let urlString = kImageURL + order.imgurl
//      roomImage.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "bg_dingdanzhuangtai"))
      var daysInfo = ""
      if let arrivalDateShortStyle = order.arrivalDateShortStyle,
        let departureDateShortStyle = order.departureDateShortStyle,
        let duration = order.duration {
          daysInfo = "\(arrivalDateShortStyle)-\(departureDateShortStyle)共\(duration.stringValue)晚"
      }
      daysLabel.text = daysInfo
      roomsTypeLabel.text = order.roomtype
      roomsTextField.text = order.roomcount.stringValue
      roomsCount = order.roomcount.integerValue
      contactTextField.text = order.orderedby
      telphoneTextField.text = order.telephone
      if order.paytype == 1 {
        paymentLabel.text = "在线支付"
        paymentLabel.textColor = UIColor.ZKJS_navTitleColor()
      }
      if order.paytype == 2 {
        paymentLabel.text = "到店支付"
        paymentLabel.textColor = UIColor.ZKJS_navTitleColor()
      }
      if order.paytype == 2 {
        paymentLabel.text = "挂账"
        paymentLabel.textColor = UIColor.ZKJS_navTitleColor()
      }
      
      paymentLabel.text = paytypeArray[order.paytype.integerValue]
      paymentLabel.textColor = UIColor.ZKJS_navTitleColor()
      isSmokingSwitch.on = order.nosmoking.boolValue
      remarkTextView.text = order.remark
      if order.company != "" {
        invoiceLabel.text = order.company
      }
      amountTextField.text = String(order.roomprice)
      orderNoLabel.text = order.orderno
      privilageLabel.text = order.privilegeName
      invoiceLabel.text = order.company
      
    }
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 || section == 7{
      return 0
    }
    return 20
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = UIColor.clearColor()
    return header
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath == NSIndexPath(forRow: 0, inSection: 1) {
      chooseDate()
    }
    if indexPath == NSIndexPath(forRow: 1, inSection: 1) {
      chooseRoomType()
    }
    if indexPath == NSIndexPath(forRow: 4, inSection: 0) {
      if type == .Update {
        // 如果是更新订单，则不能修改预定人
        return
      }
      chooseClient()
    }
    if indexPath == NSIndexPath(forRow: 0, inSection: 3) {
      choosePayStatus()
    }
    if indexPath == NSIndexPath(forRow: 1, inSection: 3) {
      let vc = InvoiceVC()
      vc.selection = { [unowned self] (invoice:  InvoiceModel) ->() in
        self.invoiceLabel.text = invoice.title
        self.invoiceLabel.textColor = UIColor.ZKJS_navTitleColor()
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
   
    view.endEditing(true)
    
  }
  
  @IBAction func submitOrder(sender: AnyObject) {
    submitOrder()
  }
  
  @IBAction func cancleOrder(sender: AnyObject) {
    ZKJSJavaHTTPSessionManager.sharedInstance().cancleOrderWithOrderNo(order.orderno, success: { (task: NSURLSessionDataTask!, responsObjects:AnyObject!)-> Void in
      if let dic = responsObjects as? NSDictionary {
        self.orderno = dic["data"] as! String
        if let result = dic["result"] as? NSNumber {
          if result.boolValue == true {
            self.sendMessageNotificationWithOderNO(self.order.orderno)
            self.navigationController?.popViewControllerAnimated(true)
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, eeror: NSError!) -> Void in
        
    }

  }
  
  func sendMessageNotificationWithOderNO(orderno: String) {
    let shopID = AccountInfoManager.sharedInstance.shopid
    if let clientID = order.userid {
      let cmdChat = EMChatCommand()
      cmdChat.cmd = "cancleOrder"
      let body = EMCommandMessageBody(chatObject: cmdChat)
      let message = EMMessage(receiver: clientID, bodies: [body])
      message.ext = ["shopId": shopID,
        "orderNo": orderno]
      message.messageType = .eMessageTypeChat
      EaseMob.sharedInstance().chatManager.asyncSendMessage(message, progress: nil)
    }
    
  }

  
  func choosePayStatus() {
    let alertView = UIAlertController(title: "选择订单状态", message: "", preferredStyle: .ActionSheet)
    for index in 1..<paytypeArray.count {
      // 关闭在线支付选项
      if index == 1 {
        continue
      }
      
      alertView.addAction(UIAlertAction(title: paytypeArray[index], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.paymentLabel.text = self.paytypeArray[index]
        self.paymentLabel.textColor = UIColor.ZKJS_navTitleColor()
        // 更新订单
        self.order.paytype = NSNumber(integer: index)
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseClient() {
//    let vc = ClientListVC()
//    vc.type = ClientListVCType.order
//    vc.selection = { [unowned self] (client: ClientModel) ->() in
//      self.clientLabel.text = client.username
//      // 更新订单
//      self.order.userid = client.userid!
//      self.order.username = client.username!
//    }
//    navigationController?.pushViewController(vc, animated: true)
  }
  
  func chooseDate() {
    let vc = BookDateSelectionViewController()
    vc.startDate = startDate
    vc.endDate = endDate
    vc.selection = { [unowned self] (startDate: NSDate, endDate: NSDate) ->() in
      self.startDate = startDate
      self.endDate = endDate
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "M/dd"
      
      let formatter = NSDateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      self.arrivaldate = formatter.stringFromDate(startDate)
      self.leavedate = formatter.stringFromDate(endDate)
      let start = dateFormatter.stringFromDate(startDate)
      let end = dateFormatter.stringFromDate(endDate)
      let duration = NSDate.ZKJS_daysFromDate(startDate, toDate: endDate)
      self.daysLabel.text = "\(start)-\(end)共\(duration)晚"
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func chooseRoomType() {
    let vc = BookRoomListVC()
    let shopID = AccountInfoManager.sharedInstance.shopid
    vc.shopid = shopID
    vc.selection = { (goods:RoomGoods ) ->() in
      self.roomsTypeLabel.text = goods.room
      self.order.roomtype = goods.room
      self.order.productid = goods.goodsid
      self.order.imgurl = goods.image
//      let urlString = kImageURL + goods.image
//      self.roomImage.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "bg_dingdanzhuangtai"))
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func switchBreakfast(sender: AnyObject) {
    if breakfeastSwitch.on == true {
      
    }
  }
  @IBAction func smokingSwitch(sender: AnyObject) {
    if isSmokingSwitch.on {
      
    }
  }
  
  // MARK: - UITextFieldDelegate
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func sendNewOrderNotificationToClientWithOrderNO(orderNO: String) {
    let shopID = AccountInfoManager.sharedInstance.shopid
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
  
  func sendNewOrderMessage() {
    // 发送环信消息
    let userName = AccountInfoManager.sharedInstance.userName
    let txtChat = EMChatText(text: "您的订单已处理，请确认")
    let body = EMTextMessageBody(chatObject: txtChat)
    let message = EMMessage(receiver: order.userid, bodies: [body])
    let ext: [String: AnyObject] = ["shopId": order.shopid,
      "shopName": order.shopname,
      "toName": order.username,
      "fromName": userName,
      "extType": 0]
    message.ext = ext
    message.messageType = .eMessageTypeChat
    EaseMob.sharedInstance().chatManager.asyncSendMessage(message, progress: nil)
  }
  
  func submitOrder() {
    if daysLabel.text == "" {
      showHint("请填写时间")
      return
    }
    if roomsTypeLabel.text == "" {
      showHint("请选择房型")
      return
    }
    if roomsTextField.text < "1" {
      showHint("请选择房间数量")
      return
    }
    if amountTextField.text == "0.0" {
      showHint("请填写价格")
      return
    }
    if paymentLabel.text == "未设置" {
      showHint("请选择支付方式")
      return
    }
    
    var orderDict = [String: AnyObject]()
    orderDict["shopid"] = AccountInfoManager.sharedInstance.shopid
    orderDict["userid"] = order.userid
    orderDict["saleid"] = AccountInfoManager.sharedInstance.userID
    orderDict["shopname"] = AccountInfoManager.sharedInstance.fullname
    orderDict["imgurl"] = order.imgurl
    orderDict["productid"] = order.productid
    orderDict["orderno"] = order.orderno
    orderDict["roomcount"] = Int(roomsTextField.text!)
    orderDict["roomtype"] = roomsTypeLabel.text!
    orderDict["paytype"] = order.paytype
    orderDict["roomprice"] = self.amountTextField.text
    orderDict["orderedby"] = contactTextField.text
    orderDict["telephone"] = telphoneTextField.text
    orderDict["arrivaldate"] = arrivaldate
    orderDict["leavedate"] = leavedate
    orderDict["personcount"] = 1
    orderDict["doublebreakfeast"] = ""
    orderDict["nosmoking"] = isSmokingSwitch.on ? 1 : 0
    orderDict["company"] = invoiceLabel.text
    orderDict["isinvoice"] = 0
    orderDict["remark"] = remarkTextView.text
    orderDict["username"] = order.username
    orderDict["orderstatus"] = 1
    
    print(orderDict)
    if type == .Update {
      if self.order.paytype.integerValue < 1 {
        ZKJSTool.showMsg("请选择支付方式")
        return
      }
      ZKJSJavaHTTPSessionManager.sharedInstance().updateOrderWithOrder(orderDict,success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        if let result = responseObject["result"] as? NSNumber {
          if result.boolValue == true {
            self.sendNewOrderNotificationToClientWithOrderNO(self.order.orderno)
            self.sendNewOrderMessage()
            self.showHint("订单已更新成功")
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
              self.navigationController?.popViewControllerAnimated(true)
            }
          }
        }
        }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      })
    } else if type == .Add {
      orderDict["orderno"] = order.orderno
      ZKJSJavaHTTPSessionManager.sharedInstance().addOrderWithCategory("0", data: orderDict, success: { (task:NSURLSessionDataTask!, responObjects:AnyObject!) -> Void in
        print(responObjects)
        self.navigationController?.popViewControllerAnimated(true)
        }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
          
      }
    }
  }
  
}

extension HotelOrderTVC: UITextViewDelegate {
  
  func textViewDidBeginEditing(textView: UITextView) {
    if textView.text == "如有其他需求，请在此说明" {
      textView.text = ""
      textView.textColor = UIColor.blackColor()
    }
    textView.becomeFirstResponder()
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView.text == "" {
      textView.text = "如有其他需求，请在此说明"
      textView.textColor = UIColor.lightGrayColor()
    }
    textView.resignFirstResponder()
  }
  
}
