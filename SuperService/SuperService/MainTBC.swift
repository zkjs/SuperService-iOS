//
//  MainTBC.swift
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

let kGotoContactList = "kGotoContactList"

class MainTBC: UITabBarController {
  var IsPresent = true
  private let conversationListVC = ConversationListController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ZKJSHTTPSessionManager.sharedInstance().delegate = self
    
    setupView()
    registerNotification()
 
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name:kYBDidReceiveMessageNotification, object: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushTo", name:kRefreshPayResultVCNotification, object: nil)
    
    // 监控Token是否过期
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveInvalidToken", name: KNOTIFICATION_LOGOUTCHANGE, object: nil)
    /*
    第一次登陆Present InfoVC 页面
    */
    presentInfoVC()
  }
  
  func presentInfoVC() {
    if let present = StorageManager.sharedInstance().presentsInfoVC() {
      self.IsPresent = present
    }
    if StorageManager.sharedInstance().noticeArray() == nil && IsPresent == true {
      let vc = InformVC()
      let nc = BaseNavigationController(rootViewController:vc)
      self.presentViewController(nc, animated: true, completion: { () -> Void in
        vc.type = ApperType.presents
        StorageManager.sharedInstance().savePresentInfoVC(true)
      })
    }
  }
  
  func pushTo() {
    let alertController = UIAlertController(title: "提示", message: "有一个订单已付款", preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
    let okAction = UIAlertAction(title: "查看", style: .Default) { (action) -> Void in

    }
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
 
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    
    if !TokenPayload.sharedInstance.isLogin {
      showLogin()
    } else {
      let userID = TokenPayload.sharedInstance.userID!
      print("EaseMob Login Name: \(userID)")
      print("登陆前环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
      
      EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(userID, password: "123456",
                                                                  completion: { (loginInfo, err) in
          print("登陆后环信:\(loginInfo)")
          if err == nil {
            EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
            let options = EaseMob.sharedInstance().chatManager.pushNotificationOptions
            options.displayStyle = .ePushNotificationDisplayStyle_simpleBanner
            EaseMob.sharedInstance().chatManager.asyncUpdatePushOptions(options)
          }
        
        }, onQueue: dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0))
      
    }
    checkVersion()
  }
  
  deinit {
    unregisterNotification()
  }
  
  // MARK: - Private
  
  private func showLogin() {
    // 清理系统缓存
    AccountInfoManager.sharedInstance.clearAccountCache()
    StorageManager.sharedInstance().clearNoticeArray()
    StorageManager.sharedInstance().clearnearBeaconLocid()
    TokenPayload.sharedInstance.clearCacheTokenPayload()
    // 消除订阅云巴频道
    YunbaSubscribeService.sharedInstance.unsubscribeAllTopics()
    YunbaSubscribeService.sharedInstance.setAlias("")
    StorageManager.sharedInstance().savePresentInfoVC(true)
    
    // 登出环信
    EaseMob.sharedInstance().chatManager.removeAllConversationsWithDeleteMessages!(true, append2Chat: true)
    let error: AutoreleasingUnsafeMutablePointer<EMError?> = nil
    print("登出前环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true)
    print("登出后环信:\(EaseMob.sharedInstance().chatManager.loginInfo)")
    self.hideHUD()
    if error != nil {
      self.showHint(error.debugDescription)
    } else {
      NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
    }
    
    let loginVC = StaffLoginVC()
    let nv = BaseNavigationController(rootViewController: loginVC)
    presentViewController(nv, animated: true, completion: nil)
  }
  
  
  private func setupView() {
    view.backgroundColor = UIColor.whiteColor()
    tabBar.tintColor = UIColor.ZKJS_themeColor()
    title = "到店通知"
    
    let vc1 = ArrivalTVC()
    vc1.tabBarItem.image = UIImage(named: "ic_daodiantongzhi")
    vc1.tabBarItem.title = "到店通知"
    let nv1 = BaseNavigationController()
    nv1.viewControllers = [vc1]
    
    /*let vc2 = OrderTVC()
    vc2.tabBarItem.title = "订单"
    vc2.tabBarItem.image = UIImage(named: "ic_dingdan")
    let nv2 = BaseNavigationController()
    nv2.viewControllers = [vc2]*/
    
    conversationListVC.tabBarItem.title = "消息"
    conversationListVC.tabBarItem.image = UIImage(named: "ic_xiaoxi")
    let nv3 = BaseNavigationController()
    nv3.viewControllers = [conversationListVC]
    
    let vc4 = ContactVC()
    vc4.tabBarItem.title = "联系人"
    vc4.tabBarItem.image = UIImage(named: "ic_lianxiren")
    let nv4 = BaseNavigationController()
    nv4.viewControllers = [vc4]
    
    let vc5 = SettingsVC()
    vc5.tabBarItem.title = "我的"
    vc5.tabBarItem.image = UIImage(named: "ic_wo")
    let nv5 = BaseNavigationController()
    nv5.viewControllers = [vc5]
    
    
    
    viewControllers = [nv1, nv3, nv4, nv5]
    
    
  }
  
  func checkVersion() {
    HttpService.sharedInstance.checkNewVersion { (isForceUpgrade, hasNewVersion) -> Void in
      if isForceUpgrade {
        // 强制更新
        let alertController = UIAlertController(title: "升级提示", message: "请您升级到最新版本，以保证软件的正常使用", preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
        let upgradeAction = UIAlertAction(title: "升级", style: .Default, handler: { (action: UIAlertAction) -> Void in
          let url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/chao-ji-shen-fen/id1018581123?ls=1&mt=8")
          if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
          }
        })
        alertController.addAction(upgradeAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      } else if hasNewVersion {
        // 提示更新
        let alertController = UIAlertController(title: "升级提示", message: "已有新版本可供升级", preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
        let upgradeAction = UIAlertAction(title: "升级", style: .Default, handler: { (action: UIAlertAction) -> Void in
          let url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/chao-ji-shen-fen/id1018581123?ls=1&mt=8")
          if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
          }
        })
        alertController.addAction(upgradeAction)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      }
      
    }
    
  }
  
  // MARK: - UITabBarControllerDelegate
  
  override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
    title = item.title
  }
  
}

extension MainTBC: EMCallManagerDelegate {
  
  // MARK: - Private
  
  func registerNotification() {
    unregisterNotification()
    
    EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    EaseMob.sharedInstance().callManager.addDelegate(self, delegateQueue: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "callOutWithChatter:", name: KNOTIFICATION_CALL, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "callControllerClose:", name: KNOTIFICATION_CALL_CLOSE, object: nil)
  }
  
  func unregisterNotification() {
    EaseMob.sharedInstance().chatManager.removeDelegate(self)
    EaseMob.sharedInstance().callManager.removeDelegate(self)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func showCodeAlertWithClientInfo(clientInfo: [String: AnyObject]) {
    let userName = clientInfo["userName"] as? String ?? ""
    let mobileNo = clientInfo["mobileNo"] as? String ?? ""
//    var date = NSDate()
//    if let timestamp = clientInfo["date"] as? NSNumber {
//      let timeInterval = Double(timestamp.longLongValue / Int64(1_000))
//      date = NSDate(timeIntervalSince1970: timeInterval)
//    }
    let alertMessage = "客人\(userName), 手机号\(mobileNo)已绑定验证码"
    let alertView = UIAlertController(title: "邀请码绑定", message: alertMessage, preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
    alertView.addAction(okAction)
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func showAddSalesAlertWithClientInfo(clientInfo: [String: AnyObject]) {
    let userName = clientInfo["userName"] as? String ?? ""
    let alertMessage = "客人\(userName)已添加你为联系人."
    let alertView = UIAlertController(title: "专属客服绑定", message: alertMessage, preferredStyle: DeviceType.IS_IPAD ?  .Alert : .ActionSheet)
    let okAction = UIAlertAction(title: "确定", style: .Default) { (action: UIAlertAction) -> Void in
      let appWindow = UIApplication.sharedApplication().keyWindow
      let mainTBC = MainTBC()
      mainTBC.selectedIndex = 3
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: kGotoContactList)
      appWindow?.rootViewController = mainTBC
    }
    alertView.addAction(okAction)
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func didReceiveCmdMessage(cmdMessage: EMMessage!) {
    if let chatObject = cmdMessage.messageBodies.first?.chatObject as? EMChatCommand {
      if chatObject.cmd == "inviteAdd" {
        // 客人已绑定验证码
        self.showCodeAlertWithClientInfo(cmdMessage.ext as! [String: AnyObject])
      } else if chatObject.cmd == "addSales" {
        // 客人已添加销售
        self.showAddSalesAlertWithClientInfo(cmdMessage.ext as! [String: AnyObject])
      }
    }
  }
  
  func didReceiveOfflineCmdMessages(offlineCmdMessages: [AnyObject]!) {
    for cmdMessage in offlineCmdMessages {
      if let cmdMessage = cmdMessage as? EMMessage {
        if let chatObject = cmdMessage.messageBodies.first?.chatObject as? EMChatCommand {
          if chatObject.cmd == "inviteAdd" {
            // 客人已绑定验证码
            self.showCodeAlertWithClientInfo(cmdMessage.ext as! [String: AnyObject])
          } else if chatObject.cmd == "addSales" {
            // 客人已添加销售
            self.showAddSalesAlertWithClientInfo(cmdMessage.ext as! [String: AnyObject])
          }
        }
      }
    }
  }
  
  func canRecord() -> Bool {
    var bCanRecord = true
    let audioSession = AVAudioSession.sharedInstance()
    if audioSession.respondsToSelector("requestRecordPermission:") {
      audioSession.requestRecordPermission({ (granted: Bool) -> Void in
        bCanRecord = granted
      })
    }
    
    if bCanRecord == false {
      // Show Alert
      showAlertWithTitle(NSLocalizedString("setting.microphoneNoAuthority", comment: "No microphone permissions"), message: NSLocalizedString("setting.microphoneAuthority", comment: "Please open in \"Setting\"-\"Privacy\"-\"Microphone\"."))
    }
    
    return bCanRecord
  }
  
  func callOutWithChatter(notification: NSNotification) {
    if let object = notification.object as? [String: AnyObject] {
      if canRecord() == false {
        return
      }
      
      guard let chatter = object["chatter"] as? String else { return }
      guard let type = object["type"] as? NSNumber else { return }
      let error: AutoreleasingUnsafeMutablePointer<EMError?> = nil
      var callSession: EMCallSession? = nil
      switch type.integerValue {
      case EMCallSessionType.eCallSessionTypeAudio.rawValue:
        callSession = EaseMob.sharedInstance().callManager.asyncMakeVoiceCall(chatter, timeout: 50, error: error)
      case EMCallSessionType.eCallSessionTypeVideo.rawValue:
        callSession = EaseMob.sharedInstance().callManager.asyncMakeVideoCall(chatter, timeout: 50, error: error)
        break
      default:
        break
      }
      
      if callSession != nil && error == nil {
        EaseMob.sharedInstance().callManager.removeDelegate(self)
        
        let callVC = CallViewController(session: callSession, isIncoming: false)
        callVC.modalPresentationStyle = .OverFullScreen
        presentViewController(callVC, animated: true, completion: nil)
      } else if error != nil {
        showAlertWithTitle(NSLocalizedString("error", comment: "error"), message: NSLocalizedString("ok", comment:"OK"))
      }
    }
  }
  
  func callControllerClose(notification: NSNotification) {
    EaseMob.sharedInstance().callManager.addDelegate(self, delegateQueue: nil)
  }
  
  func didReceiveMessage(message: EMMessage!) {
    let notification = UILocalNotification()
    notification.alertBody = "您有一条新消息"
    notification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.sharedApplication().presentLocalNotificationNow(notification)
  }
  
  // 未读消息数量变化回调
  
  func didUnreadMessagesCountChanged() {
    setupUnreadMessageCount()
  }
  
  func didFinishedReceiveOfflineMessages() {
    setupUnreadMessageCount()
  }
  
  func setupUnreadMessageCount() {
    if let conversations = EaseMob.sharedInstance().chatManager.conversations {
      var unreadCount = 0
      for conversation in conversations {
        if let conversation = conversation as? EMConversation {
          unreadCount += Int(conversation.unreadMessagesCount())
        }
      }
      
      if unreadCount > 0 {
        conversationListVC.tabBarItem.badgeValue = "\(unreadCount)"
      } else {
        conversationListVC.tabBarItem.badgeValue = nil
      }
      UIApplication.sharedApplication().applicationIconBadgeNumber = unreadCount
    }
  }

}

extension MainTBC: IChatManagerDelegate {
  
  func callSessionStatusChanged(callSession: EMCallSession!, changeReason reason: EMCallStatusChangedReason, error: EMError!) {
    if callSession.status == .eCallSessionStatusConnected {
//      var error: EMError? = nil
      let isShowPicker = NSUserDefaults.standardUserDefaults().objectForKey("isShowPicker")
      if isShowPicker != nil && isShowPicker!.boolValue == true {
//        error = EMError(code: EMErrorType.InitFailure, andDescription: NSLocalizedString("call.initFailed", comment: "Establish call failure"))
        EaseMob.sharedInstance().callManager.asyncEndCall(callSession.sessionId, reason: .eCallReason_Hangup)
        return
      }
      
      if canRecord() == false {
//        error = EMError(code: EMErrorType.InitFailure, andDescription: NSLocalizedString("call.initFailed", comment: "Establish call failure"))
        EaseMob.sharedInstance().callManager.asyncEndCall(callSession.sessionId, reason: .eCallReason_Hangup)
        return
      }
      
      if callSession.type == EMCallSessionType.eCallSessionTypeVideo &&
        (UIApplication.sharedApplication().applicationState != UIApplicationState.Active || CallViewController.canVideo() == false) {
//          error = EMError(code: EMErrorType.InitFailure, andDescription: NSLocalizedString("call.initFailed", comment: "Establish call failure"))
          EaseMob.sharedInstance().callManager.asyncEndCall(callSession.sessionId, reason: .eCallReason_Hangup)
          return
      }
      
      if isShowPicker == nil || isShowPicker!.boolValue == false {
        EaseMob.sharedInstance().callManager.removeDelegate(self)
        let callVC = CallViewController(session: callSession, isIncoming: true)
        callVC.modalPresentationStyle = .OverFullScreen
        presentViewController(callVC, animated: true, completion: nil)
        if ((navigationController?.topViewController?.isKindOfClass(ChatViewController)) == true) {
          let chatVC = navigationController?.topViewController as! ChatViewController
          chatVC.isViewDidAppear = false
        }
      }
    }
  }
  
  // MARK: - IChatManagerDelegate 登录状态变化
  
  func didLoginWithInfo(loginInfo: [NSObject : AnyObject]!, error: EMError!) {
    if error != nil {
      NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
      let messageCenterIndex = 2
      let vc = childViewControllers[messageCenterIndex] as! ConversationListController
      vc.isConnect(false) 
    }
  }
  
  func didLoginFromOtherDevice() {
    //NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
    //showLogin()
    //ZKJSTool.showMsg("账号在别处登录，请重新重录。")
  }
  
  func didRemovedFromServer() {
    NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
  }
  
  func didServersChanged() {
    NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
  }
  
  func didAppkeyChanged() {
    NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
  }
  
  func onMessageReceived(notification: NSNotification) {
    guard let nav = self.selectedViewController as? UINavigationController else {
      return
    }
    if let message = notification.object as? YBMessage {
      let payloadString = String(data: message.data, encoding: NSUTF8StringEncoding)
      print("[message] \(message.topic) => \(payloadString)")
      let json = JSON(data: message.data)
      if json["type"].string == "PAYMENT_RESULT" {
        let result = FacePayPushResult(json: json["data"])
        let orderno = result.orderno
        let storyboard = UIStoryboard(name: "CheckoutCounter", bundle: nil)
        let paymentListVC = storyboard.instantiateViewControllerWithIdentifier("PaymentListVC") as! PaymentListVC
        paymentListVC.orderNo = orderno
        if orderno.isEmpty {
          nav.pushViewController(paymentListVC, animated: true)
        } else {
          nav.pushViewController(paymentListVC, animated: false)
        }
      }
    }
  }
  
}

// MARK: - HTTPSessionManagerDelegate

extension MainTBC: HTTPSessionManagerDelegate {
  
  func didReceiveInvalidToken() {
    showLogin()
    ZKJSTool.showMsg("账号在别处登录，请重新重录")
  }
  
}
