//
//  AppDelegate.swift
//  SuperService
//
//  Created by Hanton on 9/21/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit
import CoreData

let kRefreshArrivalTVCNotification = "refreshArrivalTVCNotification"
let kRefreshConversationListNotification = "refreshConversationListNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TCPSessionManagerDelegate {
  
  var window: UIWindow?
  var mainTBC: MainTBC!
  
  // MARK: - Application Delegate
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    customizeWindow()
    setupNotification()
    setupTCPSessionManager()
    setupWindows()
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    print("applicationWillResignActive")
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    print("applicationDidEnterBackground")
    let timestamp = Int64(NSDate().timeIntervalSince1970)
    let userID = AccountManager.sharedInstance().userID
    let dictionary: [String: AnyObject] = [
      "type": MessageIMType.ClientLogout.rawValue,
      "timestamp": NSNumber(longLong: timestamp),
      "id": userID,
      "platform": "I"
    ]
    ZKJSTCPSessionManager.sharedInstance().sendPacketFromDictionary(dictionary)
    ZKJSTCPSessionManager.sharedInstance().deinitNetworkCommunication()
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    print("applicationWillEnterForeground")
    ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    print("applicationDidBecomeActive")
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    print("applicationWillTerminate")
  }
  
  
  // MARK: - Push Notification
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    print(deviceToken)
    let trimEnds = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
    let cleanToken = trimEnds.stringByReplacingOccurrencesOfString(" ", withString: "", options: .CaseInsensitiveSearch, range: nil)
    AccountManager.sharedInstance().saveDeviceToken(cleanToken)
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print(error)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    print(userInfo)
    guard let childType = userInfo["childtype"] as? NSNumber else {
      completionHandler(.NoData)
      return
    }
    
    if childType.integerValue == MessageUserDefineType.ClientArrival.rawValue {
      if let clientID = userInfo["userid"] as? String,
        let _ = userInfo["username"] as? String,
        let locationID = userInfo["locid"] as? String,
        let locationName = userInfo["locdesc"] as? String {
          ZKJSHTTPSessionManager.sharedInstance().clientArrivalInfoWithClientID(clientID,
            success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
              // 缓存到店信息到数据库
              let moc = Persistence.sharedInstance().managedObjectContext
              let clientArrivalInfo = NSEntityDescription.insertNewObjectForEntityForName("ClientArrivalInfo",
                inManagedObjectContext: moc!) as! ClientArrivalInfo
              // 客户信息
              let client = NSEntityDescription.insertNewObjectForEntityForName("Client",
                inManagedObjectContext: moc!) as! Client
              client.id = responseObject["userid"] as? String
              client.name = responseObject["username"] as? String
              client.level = responseObject["user_level"] as? NSNumber
              client.phone = (responseObject["phone"] as! NSNumber).stringValue
              clientArrivalInfo.client = client
              // 位置信息
              let location = NSEntityDescription.insertNewObjectForEntityForName("Location",
                inManagedObjectContext: moc!) as! Location
              location.id = locationID
              location.name = locationName
              clientArrivalInfo.location = location
              // 订单信息
              if let orderInfo = responseObject["order"] as? [String: AnyObject] {
                let arrivalDate = orderInfo["arrival_date"] as! String
                let departureDate = orderInfo["departure_date"] as! String
                let order = NSEntityDescription.insertNewObjectForEntityForName("Order",
                  inManagedObjectContext: moc!) as! Order
                order.roomType = orderInfo["room_type"] as? String
                order.arrivalDate = arrivalDate
                let days = NSDate.ZKJS_daysFromDateString(arrivalDate, toDateString: departureDate)
                if days == 0 {
                  order.duration = 1  // 当天走的也算一天
                } else if days > 0 {
                  order.duration = days
                } else {
                  order.duration = 0
                }
                clientArrivalInfo.order = order
              }
              clientArrivalInfo.timestamp = NSDate()
              Persistence.sharedInstance().saveContext()
              
              // 置到店通知Tab Bar
              let mainTabIndex = 0
              if self.mainTBC.selectedIndex != mainTabIndex {
                let tabArray = self.mainTBC.tabBar.items as NSArray!
                let tabItem = tabArray.objectAtIndex(mainTabIndex) as! UITabBarItem
                tabItem.badgeValue = "1"
              }
              
              NSNotificationCenter.defaultCenter().postNotificationName(kRefreshArrivalTVCNotification, object: self)
              completionHandler(.NewData)
            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
              completionHandler(.Failed)
          }
      }
      
      completionHandler(.NoData)
    }
    
    completionHandler(.NoData)
  }
  
  
  // MARK: - Private Method
  
  private func customizeWindow() {
    window?.layer.cornerRadius = 5
    window?.layer.masksToBounds = true
  }
  
  private func setupNotification() {
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  private func setupTCPSessionManager() {
    ZKJSTCPSessionManager.sharedInstance().delegate = self
  }
  
  private func setupWindows() {
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
    
    let vc3 = MessageTVC()
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
    
    mainTBC = MainTBC()
    mainTBC.viewControllers = [nv1, nv2, nv3, nv4, nv5]
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.rootViewController = mainTBC
    window?.makeKeyAndVisible()
  }
  
  
  // MARK: - TCPSessionManagerDelegate
  
  func didOpenTCPSocket() {
    // 端口连接后发登陆包
    let userID = AccountManager.sharedInstance().userID
    let userName = AccountManager.sharedInstance().userName
    let deviceToken = AccountManager.sharedInstance().deviceToken
    let shopID = AccountManager.sharedInstance().shopID
    let beaconLocationIDs = AccountManager.sharedInstance().beaconLocationIDs
    if userID.isEmpty == false {
      ZKJSTCPSessionManager.sharedInstance().loginWithUserID(userID,
        userName: userName,
        deviceToken: deviceToken,
        shopID: shopID,
        beaconLocationIDs: beaconLocationIDs)
    }
  }
  
  func didReceivePacket(dictionary: [NSObject : AnyObject]!) {
    print(dictionary)
    if let type = dictionary["type"] as? NSNumber {
      if let messageType = MessageServiceChatType(rawValue: type.integerValue) {
        // 消息类型
        handleChatMessageWithType(messageType, dictionary: dictionary)
      }
    }
  }
  
  func handleChatMessageWithType(type: MessageServiceChatType, dictionary: [NSObject: AnyObject]) {
    if [MessageServiceChatType.TextChat, .ImgChat, .MediaChat].contains(type) {
      // 文本，图片，语音消息
      let number = dictionary["timestamp"] as! NSNumber
      let timestamp = NSDate(timeIntervalSince1970: number.doubleValue)
      let sessionID = dictionary["sessionid"] as! String
      let fromID = dictionary["fromid"] as! String
      let fromName = dictionary["fromname"] as! String
      switch type {
      case .TextChat:
        Persistence.sharedInstance().saveConversationWithSessionID(sessionID,
          otherSideID: fromID,
          otherSideName: fromName,
          lastChat: dictionary["textmsg"] as! String,
          timestamp: timestamp)
      case .MediaChat:
        Persistence.sharedInstance().saveConversationWithSessionID(sessionID,
          otherSideID: fromID,
          otherSideName: fromName,
          lastChat: "[语音]",
          timestamp: timestamp)
      case .ImgChat:
        Persistence.sharedInstance().saveConversationWithSessionID(sessionID,
          otherSideID: fromID,
          otherSideName: fromName,
          lastChat: "[图片]",
          timestamp: timestamp)
      default:
        break
      }
      NSNotificationCenter.defaultCenter().postNotificationName(kRefreshConversationListNotification, object: self)
      let messageTabIndex = 1
      if mainTBC.selectedIndex != messageTabIndex {
        let tabArray = mainTBC.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(messageTabIndex) as! UITabBarItem
        tabItem.badgeValue = "1"
      }
    }
  }
  
}

