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
  var goods: RoomGoods!
  var type = HotelOrderType.Update
  var orderno = ""
  var clientID = ""
  var order = OrderModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = shopName
    roomImage.image = UIImage(named: "bg_dingdanzhuangtai")
  
    if type == .Update {
      loadData()
    } else if type == .Add {
      setUpUI()
    }
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
    roomImage.sd_setImageWithURL(NSURL(string: urlString))
    daysLabel.text = "\(order.arrivalDateShortStyle!)-\(order.departureDateShortStyle!)共\(order.duration)晚"
    roomsTypeLabel.text = order.roomtype
    roomsTextField.text = order.roomcount.stringValue
    contactTextField.text = order.username
    telphoneTextField.text = order.telephone
//    paymentLabel.text = ""
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
    if indexPath == NSIndexPath(forRow: 0, inSection: 5) {
      
    }
    
  }
  
  @IBAction func submitOrder(sender: AnyObject) {
    submitOrder()
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
    let vc = BookVC()
    let shopIDString = AccountManager.sharedInstance().shopID
    vc.shopid = NSNumber(integer: Int(shopIDString)!)
    vc.selection = { (goods:RoomGoods ) ->() in
      self.roomsTypeLabel.text = goods.room + goods.type
      self.goods = goods
      let urlString = kBaseURL + goods.image
      self.roomImage.sd_setImageWithURL(NSURL(string: urlString))
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func switchBreakfast(sender: AnyObject) {
    if  breakfeastSwitch.on == true {
      
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
  
  func submitOrder() {
    var dic = [String: AnyObject]()
    dic["saleid"] = AccountManager.sharedInstance().userID
    dic["arrivaldate"] = arrivaldate
    dic["leavedate"] = leavedate
    dic["roomtype"] = roomsTypeLabel.text!
    dic["roomcount"] = Int(roomsTextField.text!)
    dic["orderedby"] = contactTextField.text
    dic["telephone"] = telphoneTextField.text
    dic["shopid"] = AccountManager.sharedInstance().shopID
    dic["userid"] = clientID
    dic["imgurl"] = goods.image
    dic["productid"] = goods.goodsid
    dic["roomno"] = ""
    dic["paytype"] = 1
    dic["roomprice"] = amountTextField.text
    dic["telephone"] = telphoneTextField.text
    dic["personcount"] = 1
    dic["doublebreakfeast"] = breakfeastSwitch.on ? 1 : 0
    dic["nosmoking"] = isSmokingSwitch.on ? 1 : 0
    dic["company"] = ""
    dic["remark"] = remarkTextView.text
    
    if arrivaldate == nil || arrivaldate.isEmpty == true {
      ZKJSTool.showMsg("请填写时间")
      return
    }
    if self.roomsTypeLabel.text == "请选择房型" {
      ZKJSTool.showMsg("请选择房型")
      return
    }
    
    if type == .Update {
      
    } else if type == .Add {
      ZKJSJavaHTTPSessionManager.sharedInstance().addOrderWithCategory("0", data: dic, success: { (task:NSURLSessionDataTask!, responObjects:AnyObject!) -> Void in
        print(responObjects)
        self.navigationController?.popViewControllerAnimated(true)
        }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
          
      }
    }
  }
  
}
