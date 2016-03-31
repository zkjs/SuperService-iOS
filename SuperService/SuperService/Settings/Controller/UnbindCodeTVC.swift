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
  var page:Int = 0
  lazy var codeArray = [String]()
    
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
    self.showHUDInView(view, withLoading: "")
    HttpService.addSingleCode("nihao") { (json, error) -> () in
      self.hideHUD()
      if let error = error {
        if let msg = error.userInfo["resDesc"] as? String {
          self.showHint(msg)
        } else {
          self.showHint("获取邀请码失败")
        }
      } else {
        if let js = json!["data"].dictionary {
          if  let code = js["saleCode"]?.string {
            self.codeArray.insert(code, atIndex: 0)
            self.tableView.reloadData()
            if self.codeArray.count < HttpService.DefaultPageSize {
              self.tableView.mj_footer.hidden = true
            }
          }
        }
      }
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
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let code = codeArray[indexPath.row]
    let alertView = UIAlertController(title: "选择分享方式", message: "", preferredStyle: .ActionSheet)
    for index in 0..<shareTypes.count {
      alertView.addAction(UIAlertAction(title: shareTypes[index], style: .Default, handler: { [unowned self] (action: UIAlertAction!) -> Void in
        guard let salecode:String = code else { return }
        HttpService.generateCodeLink({ (json, error) -> () in
          if let _ = error {
            
          } else {
            if let dic = json!["data"].dictionary {
              if let url = dic["joinpage"]?.string {
                switch index {
                case 0:
                  self.shareByMessageWithURL(url, code: salecode)
                case 1:
                  self.shareByWeChatWithURL(url,code: salecode)
                default:
                  print("impossible")
                }
              }
              }
          }
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
      let userName = AccountInfoManager.sharedInstance.userName
      let messageComposeVC = MFMessageComposeViewController()
      messageComposeVC.messageComposeDelegate = self
      messageComposeVC.body = "\(userName): \(code)  邀请您激活超级身份。激活超级身份，把您在某商家的会员保障扩展至全国，100+顶级商户和1000＋客服将竭诚为您服务。链接：\(url)"
      presentViewController(messageComposeVC, animated: true, completion: nil)
    } else {
      let errorAlert = UIAlertView(title: "不能发送", message: "你的设备没有短信功能", delegate: self, cancelButtonTitle: "确定")
      errorAlert.show()
    }
  }
  
  func shareByWeChatWithURL(url: String,code:String) {
    let userName = AccountInfoManager.sharedInstance.userName
    let message = WXMediaMessage()
    message.title = "\(userName)\(code) 邀请您激活超级身份"
    message.description = "激活超级身份，把您在某商家的会员保障扩展至全国，100+顶级商户和1000＋客服将竭诚为您服务。"
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
    page = 0
    loadData(page)
  }
  
  func loadData(page:AnyObject) {
    HttpService.getCodeList(0, page:Int(page as! NSNumber)) { (json, error) -> () in
      if let _ = error {
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      } else {
        if let datas = json?["data"].dictionary {
          if let data = datas["salecodes"]!.array where data.count > 0 {
            if self.page == 0 {
              self.codeArray.removeAll()
            }
            for userData in data {
              let user = CodeModel(json: userData)
              if let salescode = user.salecode {
              self.codeArray.append(salescode)
             }
            }
            self.tableView.reloadData()
            self.page++
            
            if data.count < HttpService.DefaultPageSize {
              self.tableView.mj_footer.hidden = true
            }
          }
          self.tableView.mj_footer.endRefreshing()
          self.tableView.mj_header.endRefreshing()
        } else {
          self.tableView.mj_footer.hidden = true
        }

      }
        
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
