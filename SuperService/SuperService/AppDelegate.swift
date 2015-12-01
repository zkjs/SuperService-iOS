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
    setupNotification()
    setupTCPSessionManager()
    setupWindows()
    setupEaseMobWithApplication(application, launchOptions: launchOptions)
    
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
  
  private func setupNotification() {
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  private func setupTCPSessionManager() {
    ZKJSTCPSessionManager.sharedInstance().delegate = self
  }
  
  private func setupWindows() {
    mainTBC = MainTBC()
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.layer.cornerRadius = 6
    window!.layer.masksToBounds = true
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
  }
  
  func setupEaseMobWithApplication(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
    #if DEBUG
      let cert = "SuperService_dev"
    #else
      let cert = "SuperService"
    #endif
    let appKey = "zkjs#svip"
    EaseMob.sharedInstance().registerSDKWithAppKey(appKey, apnsCertName: cert, otherConfig: [kSDKConfigEnableConsoleLogger: NSNumber(bool: false)])
    EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}