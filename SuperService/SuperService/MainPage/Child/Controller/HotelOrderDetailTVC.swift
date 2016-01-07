//
//  HotelOrderDetailTVC.swift
//  SVIP
//
//  Created by AlexBang on 16/1/3.
//  Copyright © 2016年 zkjinshi. All rights reserved.
//

import UIKit

class HotelOrderDetailTVC:  UITableViewController {
  
  @IBOutlet weak var pendingConfirmationLabel: UILabel!
  @IBOutlet weak var invoiceLabel: UILabel!
  @IBOutlet weak var contacterLabel: UILabel!
  @IBOutlet weak var telphotoLabel: UILabel!
  @IBOutlet weak var smokingLabel: UILabel!
  @IBOutlet weak var breakbreastLabel: UILabel!
  @IBOutlet weak var arrivateLabel: UILabel!
  @IBOutlet weak var roomTypeLabel: UILabel!
  @IBOutlet weak var roomsCountLabel: UILabel!
  @IBOutlet weak var payTypeLabel: UILabel!
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
  
  func setUI() {
    arrivateLabel.text = "\(order.arrivalDateShortStyle!)-\(order.departureDateShortStyle!)共\(order.duration!)晚"
    roomTypeLabel.text = order.roomtype
    roomsCountLabel.text = String(order.roomcount)
    contacterLabel.text = order.orderedby
    telphotoLabel.text = order.telephone
    invoiceLabel.text = order.company
    if order.paytype == 1 {
      payTypeLabel.text = "在线支付"
      payButton.setTitle("￥\(order.roomprice)立即支付", forState: .Normal)
      payButton.addTarget(self, action: "pay:", forControlEvents: .TouchUpInside)
      cancleButton.addTarget(self, action: "cancle:", forControlEvents: .TouchUpInside)
    } else if order.paytype == 2 {
      payTypeLabel.text = "到店支付"
    } else if order.paytype == 3 {
      payTypeLabel.text = "挂帐"
    }
    if order.paytype == 0 {
      payButton.hidden = true
      pendingConfirmationLabel.text = "  请您核对订单，并确认。如需修改，请联系客服"
    }
    if order.orderstatus == "待确认" {
      payButton.addTarget(self, action: "confirm:", forControlEvents: .TouchUpInside)
      cancleButton.addTarget(self, action: "cancle:", forControlEvents: .TouchUpInside)
    }
  }
  
  func confirm(sender:UIButton) {
    
  }
  
  func cancle(sender:UIButton) {

  }
  
  func pay(sender:UIButton) {
    
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    // 确定
    if indexPath.section == 5 {
      if order.orderstatus != nil {
        if order.orderstatus == "已确认" || order.orderstatus == "已取消" {
          return 0.0
        }
      }
      
      if order.paytype != nil && order.paytype.integerValue == 0 {
        return 0.0
      }
    }
    
    // 取消
    if indexPath.section == 6 {
      if order.orderstatus != nil {
        if order.orderstatus == "已确认" || order.orderstatus == "已取消" {
          return 0.0
        }
      }
    }
    
    return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
  }
  
}
