//
//  MainTBC.swift
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {
  
  private let conversationListVC = ConversationListController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ZKJSHTTPSessionManager.sharedInstance().delegate = self
    
    setupView()
    registerNotification()
    
    print("userID: \(AccountManager.sharedInstance().userID)")
    print("Token: \(AccountManager.sharedInstance().token)")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if AccountManager.sharedInstance().userID.isEmpty {
      showLogin()
    } else {
      checkVersion()
    }
  }
  
  deinit {
    unregisterNotification()
  }
  
  // MARK: - Private
  
  private func showLogin() {
    let loginVC = StaffLoginVC()
    let nv = BaseNavigationController(rootViewController: loginVC)
//    nv.navigationBar.barTintColor = UIColor.ZKJS_themeColor()
//    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//    nv.navigationBar.translucent = false
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
    
    let vc2 = OrderTVC()
    vc2.tabBarItem.title = "订单"
    vc2.tabBarItem.image = UIImage(named: "ic_dingdan")
    let nv2 = BaseNavigationController()
    nv2.viewControllers = [vc2]
    
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
    
    viewControllers = [nv1, nv2, nv3, nv4, nv5]
  }
  
  func checkVersion() {
    let buildNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    let version = NSNumber(longLong: Int64(buildNumber)!)
    ZKJSJavaHTTPSessionManager.sharedInstance().checkVersionWithVersion(version, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let isForceUpgrade = responseObject["isForceUpgrade"] as? NSNumber {
        if let versionNo = responseObject["versionNo"] as? NSNumber {
          if versionNo.longLongValue > version.longLongValue {
            if isForceUpgrade.integerValue == 0 {
              // 提示更新
              let alertController = UIAlertController(title: "升级提示", message: "已有新版本可供升级", preferredStyle: .Alert)
              let upgradeAction = UIAlertAction(title: "升级", style: .Default, handler: { (action: UIAlertAction) -> Void in
                let url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/chao-ji-fu-wu/id1048366534?ls=1&mt=8")
                if UIApplication.sharedApplication().canOpenURL(url!) {
                  UIApplication.sharedApplication().openURL(url!)
                }
              })
              alertController.addAction(upgradeAction)
              let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
              alertController.addAction(cancelAction)
              self.presentViewController(alertController, animated: true, completion: nil)
            } else if isForceUpgrade.integerValue == 1 {
              // 强制更新
              let alertController = UIAlertController(title: "升级提示", message: "请您升级到最新版本，以保证软件的正常使用", preferredStyle: .Alert)
              let upgradeAction = UIAlertAction(title: "升级", style: .Default, handler: { (action: UIAlertAction) -> Void in
                let url  = NSURL(string: "itms-apps://itunes.apple.com/us/app/chao-ji-fu-wu/id1048366534?ls=1&mt=8")
                if UIApplication.sharedApplication().canOpenURL(url!) {
                  UIApplication.sharedApplication().openURL(url!)
                }
              })
              alertController.addAction(upgradeAction)
              self.presentViewController(alertController, animated: true, completion: nil)
            }
          }
        }
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
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
    var date = NSDate()
    if let timestamp = clientInfo["date"] as? NSNumber {
      let timeInterval = Double(timestamp.longLongValue / Int64(1_000))
      date = NSDate(timeIntervalSince1970: timeInterval)
    }
    let alertMessage = "客人\(userName), 手机号\(mobileNo)已绑定验证码-\(date.timeAgoSinceDate(date))"
    let alertView = UIAlertController(title: "邀请码绑定", message: alertMessage, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "知道了", style: .Cancel, handler: nil)
    alertView.addAction(okAction)
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func didReceiveCmdMessage(cmdMessage: EMMessage!) {
    if let chatObject = cmdMessage.messageBodies.first?.chatObject as? EMChatCommand {
      if chatObject.cmd == "inviteAdd" {
        // 客人已绑定验证码
        self.showCodeAlertWithClientInfo(cmdMessage.ext as! [String: AnyObject])
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
      var error: EMError? = nil
      let isShowPicker = NSUserDefaults.standardUserDefaults().objectForKey("isShowPicker")
      if isShowPicker != nil && isShowPicker!.boolValue == true {
        error = EMError(code: EMErrorType.InitFailure, andDescription: NSLocalizedString("call.initFailed", comment: "Establish call failure"))
        EaseMob.sharedInstance().callManager.asyncEndCall(callSession.sessionId, reason: .eCallReason_Hangup)
        return
      }
      
      if canRecord() == false {
        error = EMError(code: EMErrorType.InitFailure, andDescription: NSLocalizedString("call.initFailed", comment: "Establish call failure"))
        EaseMob.sharedInstance().callManager.asyncEndCall(callSession.sessionId, reason: .eCallReason_Hangup)
        return
      }
      
      if callSession.type == EMCallSessionType.eCallSessionTypeVideo &&
        (UIApplication.sharedApplication().applicationState != UIApplicationState.Active || CallViewController.canVideo() == false) {
          error = EMError(code: EMErrorType.InitFailure, andDescription: NSLocalizedString("call.initFailed", comment: "Establish call failure"))
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
    NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: NSNumber(bool: false))
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
  
}

// MARK: - HTTPSessionManagerDelegate

extension MainTBC: HTTPSessionManagerDelegate {
  
  func didReceiveInvalidToken() {
    showLogin()
    ZKJSTool.showMsg("账号在别处登录，请重新重录")
  }
  
}
