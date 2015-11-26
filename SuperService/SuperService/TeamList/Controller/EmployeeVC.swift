//
//  EmployeeVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
import MessageUI
class EmployeeVC: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate {
  var employee = TeamModel()
  var headerView = CodeHeaderView()
  var originY:CGFloat = 0
  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController!.navigationBar.translucent = true
      self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
      self.navigationController!.navigationBar.shadowImage = UIImage()
      let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: nil)
      let item2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancle:")
      self.navigationItem.rightBarButtonItem = item1
      self.navigationItem.leftBarButtonItem = item2
      let nibName = UINib(nibName: EmployeeCell.nibName(), bundle: nil)
      tableView.registerNib(nibName, forCellReuseIdentifier: EmployeeCell.reuseIdentifier())
      tableView.tableFooterView = UIView()
      tableView.scrollEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("EmployeeVC", owner:self, options:nil)
  }
  func cancle(sender:UIButton) {
    navigationController!.navigationBar.translucent = false
    navigationController?.popViewControllerAnimated(true)
    
  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    tableView.reloadData()
  }
   //用来指示一条消息能否从用户处发送
  func canSendText() -> Bool{
    return MFMessageComposeViewController.canSendText()
  }
  
  func configuredMessageComposeViewController() -> MFMessageComposeViewController{
    let messageComposeVC = MFMessageComposeViewController()
    messageComposeVC.messageComposeDelegate = self
    messageComposeVC.recipients = [(employee.phone?.stringValue)!]
   // messageComposeVC.body = "HI! \(caipinArray[0].rest) 的 \(caipinArray[0].name) 味道很不错，邀你共享 -来自SoFun的邀请"
    return messageComposeVC
    
  }
  
  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
    let offsetY = scrollView.contentOffset.y
    if (offsetY > 50) {
      let alpha = min(1, 1 - ((50 + 64 - offsetY) / 64))
      self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
      
    } else {
      self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return EmployeeCell.height()
  }
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 200
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EmployeeCell", forIndexPath:indexPath) as! EmployeeCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.sendMessageButton.addTarget(self, action: "sendMessage:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.setData(employee)
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    headerView = (NSBundle.mainBundle().loadNibNamed("CodeHeaderView", owner: self, options: nil).first as? CodeHeaderView)!
    self.view.addSubview(headerView)
    headerView.employeeNameLabel.text = employee.name
    return headerView
  }
  
  //对话
  @IBAction func dialogue(sender: AnyObject) {
    
  }
  //短信
  func sendMessage(sender:UIButton) {
    if self.canSendText(){
      let messageVC = self.configuredMessageComposeViewController()
      presentViewController(messageVC, animated: true, completion: nil)
    } else {
      let errorAlert = UIAlertView(title: "不能发送", message: "你的设备没有短信功能", delegate: self, cancelButtonTitle: "取消")
      errorAlert.show()
    }
  }
  
}
