
//  AppDelegate.swift
//  SuperService
//
//  Created by Hanton on 9/21/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit
import CoreData

let kRefreshArrivalTVCNotification = "kRefreshArrivalTVCNotification"
let kRefreshConversationListNotification = "kRefreshConversationListNotification"
let kArrivalInfoBadge = "kArrivalInfoBadge"
let kRefreshPayResultVCNotification = "kRefreshPayResultVCNotification"
let sharedUserActivityType = "com.zkjinshi.SuperService.WatchOpenApp"
let sharedIdentifierKey = "identifier"

var page = 1
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
  
  var window: UIWindow?
  var mainTBC: MainTBC!
  var orderArray = [OrderListModel]()

  // MARK: - Application Delegate
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    setupNotification()
    setupWindows()
    setupYunBa()
    setupWeChat()
    setupEaseMobWithApplication(application, launchOptions: launchOptions)
    clearImageCache()
    refreshToken()
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
//    setupBackgroundFetch()
    
//    #if DEBUG
//      subscribeTestTopic()
//    #endif
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name:kYBDidReceiveMessageNotification, object: nil)
    
    return true
  }
  
  func subscribeTestTopic() {
    let topic = NSNumber(integer: 30)
    YunBaService.subscribe(topic.stringValue) { (success: Bool, error: NSError!) -> Void in
      if success {
        print("[result] subscribe to topic 30 succeed")
      } else {
        print("[result] subscribe to topic 30 failed: \(error), recovery suggestion: \(error.localizedRecoverySuggestion)")
      }
    }
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    print("applicationDidEnterBackground")
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    print("applicationWillEnterForeground")
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    print("applicationDidBecomeActive")
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    print("applicationWillTerminate")
  }
  
  // MARK: - Handoff
  
  func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
    if (userActivityType == sharedUserActivityType) {
      return true
    }
    return false
  }

  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    if (userActivity.activityType == sharedUserActivityType) {
      if let userInfo = userActivity.userInfo as? [String : AnyObject] {
        if let identifier = userInfo[sharedIdentifierKey] as? Int {
          //Do something
          let alert = UIAlertView(title: "Handoff", message: "Handoff has been triggered for identifier \(identifier)" , delegate: nil, cancelButtonTitle: "Thanks for the info!")
          alert.show()
          return true
        }
      }
    }
    return false
  }
  
  
  // MARK: - Background Fetch
  
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    print("BackGround Fetch success")
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5  * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
      completionHandler(UIBackgroundFetchResult.NewData)
      page++
      ZKJSJavaHTTPSessionManager.sharedInstance().getOrderListWithPage(String(page),
        success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          print("Background Fetch: \(responseObject)")
          if let array = responseObject as? NSArray {
            for dic in array {
              let order = OrderListModel(dic: dic as! [String:AnyObject])
              if let userid = order.userid {
                if let url = NSURL(string: "http://svip02.oss-cn-shenzhen.aliyuncs.com/uploads/users/\(userid).jpg") {
                  let requestURL: NSURL = url
                  let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
                  let session = NSURLSession.sharedSession()
                  let task = session.dataTaskWithRequest(urlRequest) {
                    (data, response, error) -> Void in
                    if error == nil {
                      if let Data = data {
                        if  let  image = UIImage(data: Data) {
                          StorageManager.sharedInstance().saveHomeImages(image, userID: order.userid)
                        }
                      }
                    } else {
                      print(error)
                    }
                  }
                  task.resume()
                }
              }
            }
          }
          
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
          
      }
    }
    
  }
  

  // MARK: - Push Notification

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    EaseMob.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    
    let trimEnds = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
    let cleanToken = trimEnds.stringByReplacingOccurrencesOfString(" ", withString: "", options: .CaseInsensitiveSearch, range: nil)
    AccountInfoManager.sharedInstance.saveDeviceToken(cleanToken)
    print("Device Token: \(cleanToken)")
    
    // 将DeviceToken 存储在YunBa的云端，那么可以通过YunBa发送APNs通知
    YunBaService.storeDeviceToken(deviceToken) { (success: Bool, error: NSError!) -> Void in
      if success {
        print("store device token to YunBa success")
      } else {
        print("store device token to YunBa failed due to: \(error)")
      }
    }
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    EaseMob.sharedInstance().application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    print(error)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    print("didReceiveRemoteNotification: \(userInfo)")
    let arrivalInfoTabIndex = 0
    if mainTBC.selectedIndex != arrivalInfoTabIndex {
      // 当前页不是到店通知页面，则置到店通知Tab Bar badge
      let tabArray = mainTBC.tabBar.items as NSArray!
      let tabItem = tabArray.objectAtIndex(arrivalInfoTabIndex) as! UITabBarItem
      var newBadge = NSNumber(integer: 1)
      if let badge = NSUserDefaults.standardUserDefaults().objectForKey(kArrivalInfoBadge) as? NSNumber {
        newBadge = NSNumber(integer: badge.integerValue + 1)
      }
      tabItem.badgeValue = newBadge.stringValue
      NSUserDefaults.standardUserDefaults().setObject(newBadge, forKey: kArrivalInfoBadge)
    } else {
      // 当前页是到店通知页面，则刷新到店通知列表
      NSNotificationCenter.defaultCenter().postNotificationName(kRefreshArrivalTVCNotification, object: self)
    }
  }
 
  func refreshToken() {
    HttpService.refreshToken(nil)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    completionHandler(.NewData)
    print("didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
    NSNotificationCenter.defaultCenter().postNotificationName(kRefreshPayResultVCNotification, object: self)
//    print(userInfo)
//    guard let _ = userInfo["childtype"] as? NSNumber else {
//      completionHandler(.NoData)
//      return
//    }
//    
//    if childType.integerValue == MessageUserDefineType.ClientArrival.rawValue {
//      if let clientID = userInfo["userid"] as? String,
//        let _ = userInfo["username"] as? String,
//        let locationID = userInfo["locid"] as? String,
//        let locationName = userInfo["locdesc"] as? String {
//          ZKJSHTTPSessionManager.sharedInstance().clientArrivalInfoWithClientID(clientID,
//            success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
//              // 缓存到店信息到数据库
//              let moc = Persistence.sharedInstance().managedObjectContext
//              let clientArrivalInfo = NSEntityDescription.insertNewObjectForEntityForName("ClientArrivalInfo",
//                inManagedObjectContext: moc!) as! ClientArrivalInfo
//              // 客户信息
//              let client = NSEntityDescription.insertNewObjectForEntityForName("Client",
//                inManagedObjectContext: moc!) as! Client
//              client.id = responseObject["userid"] as? String
//              client.name = responseObject["username"] as? String
//              client.level = responseObject["user_level"] as? NSNumber
//              client.phone = (responseObject["phone"] as! NSNumber).stringValue
//              clientArrivalInfo.client = client
//              // 位置信息
//              let location = NSEntityDescription.insertNewObjectForEntityForName("Location",
//                inManagedObjectContext: moc!) as! Location
//              location.id = locationID
//              location.name = locationName
//              clientArrivalInfo.location = location
//              // 订单信息
//              if let orderInfo = responseObject["order"] as? [String: AnyObject] {
//                let arrivalDate = orderInfo["arrival_date"] as! String
//                let departureDate = orderInfo["departure_date"] as! String
//                let order = NSEntityDescription.insertNewObjectForEntityForName("Order",
//                  inManagedObjectContext: moc!) as! Order
//                order.roomType = orderInfo["room_type"] as? String
//                order.arrivalDate = arrivalDate
//                let days = NSDate.ZKJS_daysFromDateString(arrivalDate, toDateString: departureDate)
//                if days == 0 {
//                  order.duration = 1  // 当天走的也算一天
//                } else if days > 0 {
//                  order.duration = days
//                } else {
//                  order.duration = 0
//                }
//                clientArrivalInfo.order = order
//              }
//              clientArrivalInfo.timestamp = NSDate()
//              Persistence.sharedInstance().saveContext()
//              
//              // 置到店通知Tab Bar
//              let mainTabIndex = 0
//              if self.mainTBC.selectedIndex != mainTabIndex {
//                let tabArray = self.mainTBC.tabBar.items as NSArray!
//                let tabItem = tabArray.objectAtIndex(mainTabIndex) as! UITabBarItem
//                tabItem.badgeValue = "1"
//              }
//              
//              NSNotificationCenter.defaultCenter().postNotificationName(kRefreshArrivalTVCNotification, object: self)
//              completionHandler(.NewData)
//            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
//              completionHandler(.Failed)
//          }
//      }
//      
//      completionHandler(.NoData)
//    }
//    
//    completionHandler(.NoData)
  }
  
  // MARK: - Private Method
  
  private func setupNotification() {
    let checkDetailAction = UIMutableUserNotificationAction()
    checkDetailAction.title = "查看详情"
    checkDetailAction.identifier = "checkDetail"
    checkDetailAction.activationMode = .Foreground
    checkDetailAction.authenticationRequired = false
    
    let arrivalInfoCategory = UIMutableUserNotificationCategory()
    arrivalInfoCategory.setActions([checkDetailAction],
      forContext: .Default)
    arrivalInfoCategory.identifier = "arrivalInfo"
    
    let categories = NSSet(array: [arrivalInfoCategory]) as? Set<UIUserNotificationCategory>
    
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: categories)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  private func setupWindows() {
    mainTBC = MainTBC()
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.layer.cornerRadius = 6
    window!.layer.masksToBounds = true
    setupGuideVC()
    window?.makeKeyAndVisible()
  }
  
  func clearImageCache() {
    EMSDImageCache.sharedImageCache().clearDisk()
  }
  
  func setupGuideVC() {
    let guideViewController = GuideVC()
    if (!(NSUserDefaults.standardUserDefaults().boolForKey("everLaunched"))) {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey:"everLaunched")
      self.window!.rootViewController = guideViewController
    } else {
      window!.rootViewController = mainTBC
    }
  }
  
  func setupEaseMobWithApplication(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
    #if DEBUG
      let cert = "SuperService_dev"
    #else
      let cert = "SuperService"
    #endif
    let appKey = "zkjs#svip"
    
    EaseSDKHelper.shareHelper().easemobApplication(application,
      didFinishLaunchingWithOptions: launchOptions,
      appkey: appKey,
      apnsCertName: cert,
      otherConfig: [kSDKConfigEnableConsoleLogger: NSNumber(bool: false)])
  }
  
  func setupWeChat() {
    let appid = "wx55cd1d05f22990a0"
    WXApi.registerApp(appid)
  }
  
  func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
    return WXApi.handleOpenURL(url, delegate: self)
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return WXApi.handleOpenURL(url, delegate: self)
  }
  
  func onReq(req: BaseReq!) {
    if req is GetMessageFromWXReq {
      // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    } else if req is ShowMessageFromWXReq {
      // 显示微信传过来的内容
    } else if req is LaunchFromWXReq {
      // 从微信启动App
    }
  }
  
  func onResp(resp: BaseResp!) {
    if resp is SendMessageToWXResp {
      // 发送媒体消息结果
    }
  }
  
  func setupYunBa() {
    let appKey = "566563014407a3cd028aa72f"
    YunBaService.setupWithAppkey(appKey)
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMessageReceived:", name: kYBDidReceiveMessageNotification, object: nil)
  }
  
  func onMessageReceived(notification: NSNotification) {
    if let message = notification.object as? YBMessage {
      if let payloadString = NSString(data:message.data, encoding:NSUTF8StringEncoding) as? String {
//        print("[Message] \(message.topic) -> \(payloadString)")
        if let data = payloadString.dataUsingEncoding(NSUTF8StringEncoding) {
          let json = JSON(data: data)
          if let type = json["type"].string where type == "PAYMENT_RESULT" {
            let payreceive = FacePayPushResult(json: json["data"])
            AccountInfoManager.sharedInstance.savePushInfoData(payreceive)
          }
        }
        
        let arrivalInfoTabIndex = 0
        if self.mainTBC.selectedIndex != arrivalInfoTabIndex {
          // 当前页不是到店通知页面，则置到店通知Tab Bar badge
          let tabArray = self.mainTBC.tabBar.items as NSArray!
          let tabItem = tabArray.objectAtIndex(arrivalInfoTabIndex) as! UITabBarItem
          var newBadge = NSNumber(integer: 1)
          if let badge = NSUserDefaults.standardUserDefaults().objectForKey(kArrivalInfoBadge) as? NSNumber {
            newBadge = NSNumber(integer: badge.integerValue + 1)
          }
          tabItem.badgeValue = newBadge.stringValue
          NSUserDefaults.standardUserDefaults().setObject(newBadge, forKey: kArrivalInfoBadge)
        } else {
          // 当前页是到店通知页面，则刷新到店通知列表
          NSNotificationCenter.defaultCenter().postNotificationName(kRefreshArrivalTVCNotification, object: self)
        }
      }
    }
  }
  
}