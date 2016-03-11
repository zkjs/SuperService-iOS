//
//  EmployeeVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
import MessageUI

@objc enum EmployeeVCType: Int {
  case team
  case client
}

class EmployeeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate {
  
  var employee = TeamModel()
  var client = AddClientModel()
  var headerView = CodeHeaderView()
  var originY:CGFloat = 0
  lazy var type = EmployeeVCType.team
  
  @IBOutlet weak var tableView: UITableView!
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("EmployeeVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //print(client)
    navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    navigationController!.navigationBar.shadowImage = UIImage()
//    let item1 = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: nil)
//    let item2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancle:")
//    navigationItem.rightBarButtonItem = item1
//    navigationItem.leftBarButtonItem = item2
    let nibName = UINib(nibName: EmployeeCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: EmployeeCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    tableView.scrollEnabled = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
     navigationController!.navigationBar.translucent = true
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController!.navigationBar.translucent = false
  }
  
  func cancle(sender:UIButton) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  //用来指示一条消息能否从用户处发送
  func canSendText() -> Bool{
    return MFMessageComposeViewController.canSendText()
  }
  
  func configuredMessageComposeViewController() -> MFMessageComposeViewController{
    let messageComposeVC = MFMessageComposeViewController()
    messageComposeVC.messageComposeDelegate = self
    if type == EmployeeVCType.team {
      messageComposeVC.recipients = [(employee.phone?.stringValue)!]
    }else {
      messageComposeVC.recipients = [(client.phone)!]
    }
    
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
    if type == EmployeeVCType.team {
     cell.setData(employee)
    }else {
      cell.setdata(client)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    headerView = (NSBundle.mainBundle().loadNibNamed("CodeHeaderView", owner: self, options: nil).first as? CodeHeaderView)!
    self.view.addSubview(headerView)
    if type == EmployeeVCType.team {
      headerView.employeeNameLabel.text = employee.name
    } else {
      headerView.employeeNameLabel.text = client.username
    }
    return headerView
  }
  
  //对话
  @IBAction func dialogue(sender: AnyObject) {
    var chatterID = ""
    var chatterName = ""
    if type == EmployeeVCType.team {
      if let salesid = employee.salesid,
        let salesname = employee.name {
        chatterID = salesid
        chatterName = salesname
      } else {
        return
      }
    } else {
      if let userid = client.userid,
        let username = client.username {
          chatterID = userid
          chatterName = username
      } else {
        return
      }
    }
    let vc = ChatViewController(conversationChatter: chatterID, conversationType: .eConversationTypeChat)
    let userName = AccountManager.sharedInstance().userName
    vc.title = chatterName
    // 扩展字段
    let ext = ["toName": chatterName,
      "fromName": userName]
    vc.conversation.ext = ext
    navigationController?.pushViewController(vc, animated: true)
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