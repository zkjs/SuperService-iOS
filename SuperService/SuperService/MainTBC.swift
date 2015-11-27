//
//  MainTBC.swift
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if AccountManager.sharedInstance().userID.isEmpty == false {
      ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
    }
    
    setupView()
    registerNotification()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if AccountManager.sharedInstance().userID.isEmpty {
      showLogin()
    }
  }
  
  deinit {
    unregisterNotification()
  }
  
  
  // MARK: - Private
  
  private func showLogin() {
    let loginVC = StaffLoginVC()
    let nv = UINavigationController(rootViewController: loginVC)
    nv.navigationBar.barTintColor = UIColor.ZKJS_themeColor()
    nv.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    nv.navigationBar.translucent = false
    presentViewController(nv, animated: true, completion: nil)
  }
  
  private func setupView() {
    
    view.backgroundColor = UIColor.whiteColor()
    tabBar.tintColor = UIColor.ZKJS_themeColor()
    title = "到店通知"
    
    let vc1 = ArrivalTVC()
    vc1.tabBarItem.image = UIImage(named: "ic_home")
    vc1.tabBarItem.title = "到店通知"
    let nv1 = BaseNavigationController()
    nv1.viewControllers = [vc1]
    
    let vc2 = OrderTVC()
    vc2.tabBarItem.title = "订单"
    vc2.tabBarItem.image = UIImage(named: "ic_dingdan")
    let nv2 = BaseNavigationController()
    nv2.viewControllers = [vc2]
    
    let vc3 = ConversationListController()
    vc3.tabBarItem.title = "消息"
    vc3.tabBarItem.image = UIImage(named: "ic_duihua_b")
    let nv3 = BaseNavigationController()
    nv3.viewControllers = [vc3]
    
    let vc4 = ContactVC()
    vc4.tabBarItem.title = "联系人"
    vc4.tabBarItem.image = UIImage(named: "ic_tuandui_b")
    let nv4 = BaseNavigationController()
    nv4.viewControllers = [vc4]
    
    let vc5 = SettingsVC()
    vc5.tabBarItem.title = "我的"
    vc5.tabBarItem.image = UIImage(named: "ic_shezhi")
    let nv5 = BaseNavigationController()
    nv5.viewControllers = [vc5]
    
    viewControllers = [nv1, nv2, nv3, nv4, nv5]
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
