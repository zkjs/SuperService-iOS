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

  @IBOutlet weak var roomImage: UIImageView!
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
    }
  }
  @IBOutlet weak var countAddButton: UIButton! {
    didSet {
      countAddButton.addTarget(self, action: "countAdd:", forControlEvents: UIControlEvents.TouchUpInside)
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
  var orderno = ""
  var clientID = ""
  var order = OrderModel()
  var paytypeArray = ["未设置", "在线支付", "到店支付", "挂帐"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = shopName
    roomImage.image = UIImage(named: "bg_dingdanzhuangtai")
  
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
    roomsCount--
    if roomsCount < 1 {
      self.countSubtractButton.enabled = false
    }
    self.roomsTextField.text = String(roomsCount)
  }
  
  func setUpUI() {
    let urlString = kBaseURL + order.imgurl
    roomImage.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "bg_dingdanzhuangtai"))
    daysLabel.text = "\(order.arrivalDateShortStyle!)-\(order.departureDateShortStyle!)共\(order.duration!)晚"
    roomsTypeLabel.text = order.roomtype
    roomsTextField.text = order.roomcount.stringValue
    contactTextField.text = order.username
    telphoneTextField.text = order.telephone
    paymentLabel.text = paytypeArray[order.paytype.integerValue]
    breakfeastSwitch.on = order.doublebreakfeast.boolValue
    isSmokingSwitch.on = order.nosmoking.boolValue
    remarkTextView.text = order.remark
    invoiceTextField.text = order.company
    clientLabel.text = order.username
    amountTextField.text = String(order.roomprice)
  }
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print(indexPath)
    
    if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
      chooseDate()
    }
    if indexPath == NSIndexPath(forRow: 2, inSection: 0) {
      chooseRoomType()
    }
    if indexPath == NSIndexPath(forRow: 4, inSection: 0) {
      if type == .Update {
        // 如果是更新订单，则不能修改预定人
        return
      }
      chooseClient()
    }
    if indexPath == NSIndexPath(forRow: 0, inSection: 2) {
      choosePayStatus()
    }
    
  }
  
  @IBAction func submitOrder(sender: AnyObject) {
    submitOrder()
  }
  
  func choosePayStatus() {
    let alertView = UIAlertController(title: "选择订单状态", message: "", preferredStyle: .ActionSheet)
    for index in 1..<paytypeArray.count {
      alertView.addAction(UIAlertAction(title: paytypeArray[index], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        self.paymentLabel.text = self.paytypeArray[index]
        // 更新订单
        self.order.paytype = NSNumber(integer: index)
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func chooseClient() {
    let vc = ClientListVC()
    vc.type = ClientListVCType.order
    vc.selection = { [unowned self] (client: ClientModel) ->() in
      self.clientLabel.text = client.username
      // 更新订单
      self.clientID = client.userid!
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func chooseDate() {
    let vc = BookDateSelectionViewController()
    vc.selection = { [unowned self] (startDate: NSDate, endDate: NSDate) ->() in
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
    let shopID = AccountManager.sharedInstance().shopID
    vc.shopid = shopID
    vc.selection = { (goods:RoomGoods ) ->() in
      self.roomsTypeLabel.text = goods.room
      self.order.productid = goods.goodsid
      self.order.imgurl = goods.image
      let urlString = kBaseURL + goods.image
      self.roomImage.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "bg_dingdanzhuangtai"))
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
  
  func submitOrder() {
    if roomsTypeLabel.text!.isEmpty == true {
      ZKJSTool.showMsg("请填写时间")
      return
    }
    if self.roomsTypeLabel.text == "请选择房型" {
      ZKJSTool.showMsg("请选择房型")
      return
    }
    
    var orderDict = [String: AnyObject]()
    orderDict["orderno"] = order.orderno
    orderDict["shopid"] = AccountManager.sharedInstance().shopID
    orderDict["userid"] = order.userid
    orderDict["saleid"] = AccountManager.sharedInstance().userID
    orderDict["shopname"] = AccountManager.sharedInstance().shopName
    orderDict["imgurl"] = order.imgurl
    orderDict["productid"] = order.productid
    orderDict["roomno"] = ""
    orderDict["roomcount"] = Int(roomsTextField.text!)
    orderDict["roomtype"] = roomsTypeLabel.text!
    orderDict["paytype"] = order.paytype
    orderDict["roomprice"] = amountTextField.text
    orderDict["orderedby"] = contactTextField.text
    orderDict["telephone"] = telphoneTextField.text
    orderDict["arrivaldate"] = arrivaldate
    orderDict["leavedate"] = leavedate
    orderDict["personcount"] = 1
    orderDict["doublebreakfeast"] = breakfeastSwitch.on ? 1 : 0
    orderDict["nosmoking"] = isSmokingSwitch.on ? 1 : 0
    orderDict["company"] = ""
    orderDict["isinvoice"] = 0
    orderDict["remark"] = remarkTextView.text
    orderDict["username"] = order.username
//    orderDict["orderstatus"] = ""
    
    print(orderDict)
    if type == .Update {
      if self.order.paytype.integerValue < 1 {
        ZKJSTool.showMsg("请选择支付方式")
        return
      }
      ZKJSJavaHTTPSessionManager.sharedInstance().updateOrderWithOrder(orderDict, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
        if let result = responseObject["result"] as? NSNumber {
          if result.boolValue == true {
            self.sendNewOrderNotificationToClientWithOrderNO(self.order.orderno)
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
      ZKJSJavaHTTPSessionManager.sharedInstance().addOrderWithCategory("0", data: orderDict, success: { (task:NSURLSessionDataTask!, responObjects:AnyObject!) -> Void in
        print(responObjects)
        self.navigationController?.popViewControllerAnimated(true)
        }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
          
      }
    }
  }
  
}
