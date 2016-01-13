//
//  HotelOrderDetailTVC.swift
//  SVIP
//
//  Created by AlexBang on 16/1/3.
//  Copyright © 2016年 zkjinshi. All rights reserved.
//

import UIKit

class HotelOrderDetailTVC:  UITableViewController {
  
  @IBOutlet weak var ordernoLabel: UILabel!
  @IBOutlet weak var privilageLabel: UILabel!
  @IBOutlet weak var pendingConfirmationLabel: UILabel!
  @IBOutlet weak var remark: UITextView!
  @IBOutlet weak var invoiceLabel: UILabel!
  @IBOutlet weak var contacterLabel: UILabel!
  @IBOutlet weak var telphotoLabel: UILabel!
  @IBOutlet weak var smokingLabel: UILabel!
  @IBOutlet weak var breakbreastLabel: UILabel!
  @IBOutlet weak var arrivateLabel: UILabel!
  @IBOutlet weak var roomTypeLabel: UILabel!
  @IBOutlet weak var roomsCountLabel: UILabel!
  @IBOutlet weak var payTypeLabel: UILabel!
  @IBOutlet weak var orderEndButton: UIButton!
  @IBOutlet weak var payButton: UIButton!
  @IBOutlet weak var cancleButton: UIButton!
  
  var orderno: String!
  var order = OrderModel()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.translucent = false
  }
  
  func loadData() {
    //获取订单详情
    guard let orderno = orderno else { return }
    showHUDInView(view, withLoading: "")
    ZKJSJavaHTTPSessionManager.sharedInstance().getOrderDetailWithOrderNo(orderno, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      self.hideHUD()
      if let dic = responseObject as? NSDictionary {
        print(dic)
        self.order = OrderModel(dic: dic as! [String : AnyObject])
        self.tableView.reloadData()
        self.setUI()
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        print(error)
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    view.endEditing(true)
  }
  
  func setUI() {
    ordernoLabel.text = order.orderno
    arrivateLabel.text = "\(order.arrivalDateShortStyle!)-\(order.departureDateShortStyle!)共\(order.duration!)晚"
    roomTypeLabel.text = order.roomtype
    roomsCountLabel.text = String(order.roomcount)
    contacterLabel.text = order.orderedby
    telphotoLabel.text = order.telephone
    invoiceLabel.text = order.company
    privilageLabel.text = order.privilegeName
    if order.paytype == 1 {
      payTypeLabel.text = "在线支付"
    }
    if order.paytype == 2 {
      payTypeLabel.text = "到店支付"
    }
    if order.paytype == 3 {
      payTypeLabel.text = "挂账"
    }
    
    if order.nosmoking == 0 {
      smokingLabel.text = "否"
    } else {
      smokingLabel.text = "是"
    }

    
    remark.text = order.remark
    remark.editable = false
  

     }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //待评价
    if indexPath.section == 5 {
      if order.orderstatus != nil {
        if  order.orderstatus == "已完成" || order.orderstatus == "待评价" || order.orderstatus == "已取消"  {
          return 0.0
        }
      }
    }
    return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 || section == 5{
      return 0
    }
    return 20
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = UIColor.clearColor()
    return header
  }

  
  @IBAction func orderEnd(sender: AnyObject) {
    
    ZKJSJavaHTTPSessionManager.sharedInstance().confirmOrderWithOrderNo(order.orderno, status: 4, success: { (task:NSURLSessionDataTask!, responsObject:AnyObject!) -> Void in
      if let result = responsObject["result"] as? NSNumber {
        if result.boolValue == true {
          self.showHint("订单已更新成功")
          self.navigationController?.popViewControllerAnimated(true)
        }
      }

      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
 
}
