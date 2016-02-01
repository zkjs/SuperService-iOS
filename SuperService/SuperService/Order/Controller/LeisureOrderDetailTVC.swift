//
//  LeisureOrderDetailTVC.swift
//  SVIP
//
//  Created by AlexBang on 16/1/4.
//  Copyright © 2016年 zkjinshi. All rights reserved.
//

import UIKit

class LeisureOrderDetailTVC: UITableViewController {

  @IBOutlet weak var roomImage: UIImageView!
  @IBOutlet weak var pendingConfirmationLabel: UILabel!
  @IBOutlet weak var cancleButton: UIButton!
  @IBOutlet weak var payButton: UIButton!
  @IBOutlet weak var remarkView: UITextView!
  @IBOutlet weak var invoiceLabel: UILabel!
  @IBOutlet weak var telphotoLabel: UILabel!
  @IBOutlet weak var contacterLabel: UILabel!
  @IBOutlet weak var personCountLabel: UILabel!
  @IBOutlet weak var arriveDateLabel: UILabel!
  
  var reservation_no: String!
  var orderno: String!
  var order = OrderModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.translucent = false
  }
  
  func loadData() {
    //获取订单详情
    ZKJSJavaHTTPSessionManager.sharedInstance().getOrderDetailWithOrderNo(reservation_no, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let dic = responseObject as? NSDictionary {
        self.order = OrderModel(dic: dic as! [String : AnyObject])
      }
      self.tableView.reloadData()
      self.setUI()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
    }
    
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath == NSIndexPath(forRow: 0, inSection: 2) {
      let alertController = UIAlertController(title: "请选择性别", message: "", preferredStyle: .ActionSheet)
      let online = UIAlertAction(title: "在线支付", style:.Default, handler: { (action: UIAlertAction) -> Void in
//        self.payTypeLabel.text =  "在线支付"
      })
      alertController.addAction(online)
      let arrvavi = UIAlertAction(title: "到店支付", style:.Default, handler: { (action: UIAlertAction) -> Void in
//        self.payTypeLabel.text =  "到店支付"
      })
      alertController.addAction(arrvavi)
      let bill = UIAlertAction(title: "挂帐", style:.Default, handler: { (action: UIAlertAction) -> Void in
//        self.payTypeLabel.text =  "挂帐"
      })
      alertController.addAction(bill)
      let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
      alertController.addAction(cancelAction)
      
      presentViewController(alertController, animated: true, completion: nil)
    }
    
  }

  
  func setUI() {
    arriveDateLabel.text = "\(order.arrivalDateShortStyle!)-\(order.departureDateShortStyle!)共\(order.duration!)晚"
    contacterLabel.text = order.orderedby
    telphotoLabel.text = order.telephone
    invoiceLabel.text = order.company
    
  }
  
  
  
  


}
