//
//  UnbindCodeTVC.swift
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit
import MessageUI

class UnbindCodeTVC: UITableViewController, MFMessageComposeViewControllerDelegate {
  
  let shareTypes = ["短信", "微信好友"]
  
  var page = 1
  lazy var codeArray = [CodeModel]()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: CodeCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CodeCell.reuseIdentifier())
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
    tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
    
    tableView.mj_header.beginRefreshing()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let addCodeButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: "addCode:")
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let baseNC = appDelegate.mainTBC.selectedViewController as! BaseNavigationController
    baseNC.topViewController?.navigationItem.rightBarButtonItem = addCodeButton
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let baseNC = appDelegate.mainTBC.selectedViewController as! BaseNavigationController
    baseNC.topViewController?.navigationItem.rightBarButtonItem = nil
  }
  
  func addCode(sender:UIButton) {
    ZKJSHTTPSessionManager.sharedInstance().theWaiterRandomAccessToanInvitationCodeSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let data = responseObject as? [String: AnyObject] {
        if let salecode = data["code"] as? String {
          let dic = [
            "salecode": salecode,
            "is_validity": NSNumber(integer: 0)
          ]
          let code = CodeModel(dic: dic)
          self.codeArray.insert(code, atIndex: 0)
          self.tableView.reloadData()
        }
      }
      }) { (task: NSURLSessionDataTask!, erroe: NSError!) -> Void in
        
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return codeArray.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CodeCell.height()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CodeCell.reuseIdentifier(), forIndexPath: indexPath) as! CodeCell
    let code = codeArray[indexPath.row]
    cell.setData(code)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let code = codeArray[indexPath.row]
    let alertView = UIAlertController(title: "选择分享方式", message: "", preferredStyle: .ActionSheet)
    
    for index in 0..<shareTypes.count {
      alertView.addAction(UIAlertAction(title: shareTypes[index], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        guard let salecode = code.salecode else { return }
        ZKJSHTTPSessionManager.sharedInstance().getInvitationLinkWithCode(salecode, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          if let data = responseObject as? [String: AnyObject] {
            if let url = data["url"] as? String {
              switch index {
              case 0:
                self.shareByMessageWithURL(url, code: salecode)
              case 1:
                self.shareByWeChatWithURL(url)
              default:
                print("impossible")
              }
            }
          }
          }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            
        })
        }))
    }
    alertView.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func shareByMessageWithURL(url: String, code: String) {
    if MFMessageComposeViewController.canSendText() {
      let userName = AccountManager.sharedInstance().userName
      let messageComposeVC = MFMessageComposeViewController()
      messageComposeVC.messageComposeDelegate = self
      messageComposeVC.body = "\(userName) 邀请您激活超级身份。激活超级身份，把您在某商家的会员保障扩展至全国，超过百家顶级商户和1000*名真人客服将竭诚为您服务。请点击链接激活\(url)，或在超级身份App中输入邀请码\(code)激活。"
      presentViewController(messageComposeVC, animated: true, completion: nil)
    } else {
      let errorAlert = UIAlertView(title: "不能发送", message: "你的设备没有短信功能", delegate: self, cancelButtonTitle: "确定")
      errorAlert.show()
    }
  }
  
  func shareByWeChatWithURL(url: String) {
    let userName = AccountManager.sharedInstance().userName
    let message = WXMediaMessage()
    message.title = "\(userName) 邀请您激活超级身份"
    message.description = "激活超级身份，把您在某商家的会员保障扩展至全国，超过百家顶级商户和1000*名真人客服将竭诚为您服务。"
    message.setThumbImage(UIImage(named: "mainIcon"))
    let ext = WXWebpageObject()
    ext.webpageUrl = url
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
    loadData(page)
  }
  
  func refreshData() {
    page = 1
    loadData(page)
  }
  
  func loadData(page:AnyObject) {
    ZKJSHTTPSessionManager.sharedInstance().getInvitationCodeWithPage(String(page), success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let data = responseObject {
        if let array = data["code_data"] as? [[String: AnyObject]] {
          if self.page == 1 {
            self.codeArray.removeAll()
          }
          for dict in array {
            let code = CodeModel(dic: dict)
            self.codeArray.append(code)
          }
          self.tableView.reloadData()
          self.page++
        }
      }
      self.tableView.mj_footer.endRefreshing()
      self.tableView.mj_header.endRefreshing()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
  }
  
}

extension UnbindCodeTVC: XLPagerTabStripChildItem {
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "未使用"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
}
