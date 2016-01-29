//
//  AddSalesVC.swift
//  SVIP
//
//  Created by AlexBang on 16/1/27.
//  Copyright © 2016年 zkjinshi. All rights reserved.
//

import UIKit

class AddSalesVC: UIViewController {
  
  @IBOutlet weak var lastLoginLabel: UILabel!
  @IBOutlet weak var shopnameLabel: UILabel!
  @IBOutlet weak var phonrLabel: UILabel!
  @IBOutlet weak var salesnameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  var salesid = ""
  var guster: GusterModel? = nil
  var shopid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "添加"
      let image = UIImage(named: "ic_fanhui_orange")
      let item1 = UIBarButtonItem(image: image, style:.Done, target: self, action: "pop:")
      self.navigationItem.leftBarButtonItem = item1
      
      salesnameLabel.text = ""
      shopnameLabel.text = ""
      phonrLabel.text = ""
      lastLoginLabel.text = ""
        // Do any additional setup after loading the view.
    }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AddSalesVC", owner:self, options:nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
    setupUI()
  }
  
  func pop(sender:UIBarButtonItem) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func setupUI() {
    if let sales = self.guster {
      let url = NSURL(string: kImageURL)?.URLByAppendingPathComponent("/uploads/users/\(sales.userid!).jpg")
      imageView.sd_setImageWithURL(url)
      salesnameLabel.text = sales.username
      salesnameLabel.sizeToFit()
      shopnameLabel.sizeToFit()
      if let phone = sales.phone {
        phonrLabel.text = String(phone)
      }
      
    }

  }
  
  func loadData() {
    ZKJSHTTPSessionManager.sharedInstance().checkGusterWithPhone(salesid, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let data = responseObject as? [String: AnyObject] {
        if let set = data["set"] as? NSNumber {
          if set.boolValue == false {
            if let err = data["err"] as? NSNumber {
              if err.integerValue == 404 {
                self.showHint("此客人不存在")
              }
            }
          } else {
            self.guster = GusterModel(dic: data)
            self.setupUI()
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }

  @IBAction func addWaiter(sender: AnyObject) {
    guard let userid = guster?.userid else { return }
    showHUDInView(view, withLoading: "")
    ZKJSHTTPSessionManager.sharedInstance().userAddwaiterWithSalesID(userid, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let data = responseObject as? [String: AnyObject] {
        if let set = data["set"] as? Bool {
          if set == true {
            NSNotificationCenter.defaultCenter().postNotificationName("addWaiterSuccess", object: self)
            self.hideHUD()
            self.showHint("添加成功")
            self.navigationController?.popViewControllerAnimated(true)
          }
          else {
            self.hideHUD()
            self.showHint("客人已被销售添加")
            self.navigationController?.popViewControllerAnimated(true)
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        self.hideHUD()
        self.showHint("客人已被销售添加")
        self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  func sendInvitationCodeNotification() {
    // 发送环信透传消息
    let userID = AccountManager.sharedInstance().userID
    let userName = AccountManager.sharedInstance().userName
    let cmdChat = EMChatCommand()
    cmdChat.cmd = "addGuest"
    let body = EMCommandMessageBody(chatObject: cmdChat)
    let message = EMMessage(receiver: salesid, bodies: [body])
    message.ext = [
      "salesId": userID,
      "salesName": userName]
    message.messageType = .eMessageTypeChat
    EaseMob.sharedInstance().chatManager.asyncSendMessage(message, progress: nil)
  }

}
