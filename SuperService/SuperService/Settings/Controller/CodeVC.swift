//
//  CodeVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
import MessageUI

class CodeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
  
  let shareTypes = ["短信", "微信好友"]
  
  var page = 1
  lazy var codeArray = [String]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: CodeCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CodeCell.reuseIdentifier())
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
    let image = UIImage(named: "ic_tianjia")
    let addCodeButton = UIBarButtonItem(image: image, style:.Plain, target: self, action: "addCode:")
    self.navigationItem.rightBarButtonItem = addCodeButton
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("CodeVC", owner:self, options:nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.mj_header.beginRefreshing()
  }
  
  func addCode(sender:UIButton) {
    ZKJSHTTPSessionManager.sharedInstance().theWaiterRandomAccessToanInvitationCodeSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      let dic = responseObject as! NSDictionary
      self.codeArray.append(dic["code"] as! String)
      self.tableView.reloadData()
      }) { (task: NSURLSessionDataTask!, erroe: NSError!) -> Void in
        
    }
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return codeArray.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CodeCell.height()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CodeCell", forIndexPath: indexPath) as! CodeCell
    let string = codeArray[indexPath.row]
    cell.setData(string)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let alertView = UIAlertController(title: "选择订单状态", message: "", preferredStyle: .ActionSheet)
    
    for index in 0..<shareTypes.count {
      alertView.addAction(UIAlertAction(title: shareTypes[index], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        switch index {
          case 0:
            self.shareByMessage()
          case 1:
            self.shareByWeChat()
        default:
          print("impossible")
        }
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
    
    //    let vc = InvitationRecordVC()
    //    vc.code = codeArray[indexPath.row]
    //    navigationController?.pushViewController(vc, animated: true)
  }
  
  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func shareByMessage() {
    if MFMessageComposeViewController.canSendText() {
      let messageComposeVC = MFMessageComposeViewController()
      messageComposeVC.messageComposeDelegate = self
      messageComposeVC.body = "XX酒店的XXX邀请您成为VIP会员，请点击链接激活。"
      presentViewController(messageComposeVC, animated: true, completion: nil)
    } else {
      let errorAlert = UIAlertView(title: "不能发送", message: "你的设备没有短信功能", delegate: self, cancelButtonTitle: "确定")
      errorAlert.show()
    }
  }
  
  func shareByWeChat() {
    let message = WXMediaMessage()
    message.title = "超级服务"
    message.description = "验证码分享"
    message.setThumbImage(UIImage(named: "Icon"))
    let ext = WXWebpageObject()
    ext.webpageUrl = "http://ww.baidu.com"
    message.mediaObject = ext
    
    let req = SendMessageToWXReq()
    req.bText = false
    req.message = message
    
    WXApi.sendReq(req)
  }
  
//  func copyShareLink() {
//    let pasteboard = UIPasteboard()
//    pasteboard.string = "the link"
//  }
  
  func loadMoreData() {
    page++
    setupData(page)
  }
  
  func refreshData() {
    page = 1
    codeArray.removeAll()
    setupData(page)
  }
  
  func setupData(page:AnyObject) {
    ZKJSHTTPSessionManager.sharedInstance().theWaiterCheckMyInvitationWithPage(String(page), pageData: "10", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      let dic = responseObject as! NSDictionary
      if let array = dic["code_data"] as? NSArray {
        for dict in array {
          let code = CodeModel(dic: dict as! [String:AnyObject])
          self.codeArray.append(code.salecode!)
        }
        self.tableView.reloadData()
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      }
      }) { (task: NSURLSessionDataTask!, erroe: NSError!) -> Void in
        
    }
  }
  
}
