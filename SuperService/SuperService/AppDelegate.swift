//
//  AppDelegate.swift
//  SuperService
//
//  Created by Hanton on 9/21/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TCPSessionManagerDelegate {

  var window: UIWindow?

  
  // MARK: - Application Delegate

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    customizeWindow()
    customizeTabBar()
    setupNotification()
    setupTCPSessionManager()
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
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
    
    ZKJSTCPSessionManager.sharedInstance().initNetworkCommunication()
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    print(userInfo)
    if let childType = userInfo["childtype"] as? NSNumber {
      if childType.integerValue == MessageUserDefineType.ClientArrival.rawValue {
        guard let clientID = userInfo["userid"] as? String else { return }
        guard let clientName = userInfo["username"] as? String else { return }
        guard let locationID = userInfo["locid"] as? String else { return }
        guard let locationName = userInfo["locdesc"] as? String else { return }
        
        let userID = AccountManager.sharedInstance().userID
        let token = AccountManager.sharedInstance().token
        let shopID = AccountManager.sharedInstance().shopID
        ZKJSHTTPSessionManager.sharedInstance().clientArrivalInfoWithUserID(userID,
          token: token,
          clientID: clientID,
          shopID: shopID,
          success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
//            {
//              order =     {
//                "arrival_date" = "2015-10-17";
//                created = "2015-10-17 05:13:01";
//                "departure_date" = "2015-10-18";
//                fullname = "\U957f\U6c99\U8c6a\U5ef7\U5927\U9152\U5e97";
//                guest = "<null>";
//                guestid = 5603d8d417392;
//                guesttel = "<null>";
//                imgurl = "uploads/rooms/1.jpg";
//                "pay_id" = 1;
//                "pay_name" = "\U652f\U4ed8\U5b9d";
//                "pay_status" = 0;
//                payment = 1;
//                remark = "<null>";
//                "reservation_no" = H20151017051301;
//                "room_rate" = 566;
//                "room_type" = "\U8c6a\U534e\U5927\U5e8a\U65e0\U65e9";
//                "room_typeid" = 1;
//                rooms = 1;
//                shopid = 120;
//                status = 0;
//              };
//              "order_count" = 1;
//              phone = 18925232944;
//              sex = 0;
//              "user_level" = 0;
//              userid = 5603d8d417392;
//              username = Hanton;
            
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
              let days = NSDate.daysFromDateString(arrivalDate, toDateString: departureDate)
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

            let alertView = UIAlertController(title: "到店通知", message: "\(clientName) 已到达 \(locationName)", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "忽略", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "查看", style: .Default, handler: {[unowned self] (action: UIAlertAction!) -> Void in
              if let mainTBC = self.window?.rootViewController as? MainTBC {
                // 跳转到主页
                mainTBC.selectedIndex = 0
                if let navigationController = mainTBC.childViewControllers.first as? UINavigationController {
                  if let mainPageVC = navigationController.viewControllers.first as? XLSegmentedPagerTabStripViewController {
                    // 跳转到到店通知页面
                    mainPageVC.moveToViewControllerAtIndex(0)
                    // Tab Bar角标置0
                    navigationController.tabBarItem.badgeValue = nil
                    // App角标置0
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                    
                    if let arrivatTVC = mainPageVC.pagerTabStripChildViewControllers.first as? ArrivalTVC {
                      arrivatTVC.refresh()
                    }
                  }
                }
              }
            }))
            self.window?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
          }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            
        }
      }
    }
  }
  
  
  // MARK: - Private Method
  
  private func customizeWindow() {
    window?.layer.cornerRadius = 5
    window?.layer.masksToBounds = true
  }
  
  private func customizeTabBar() {
    let attribute = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UITabBarItem.appearance().setTitleTextAttributes(attribute, forState: UIControlState.Normal)
    UITabBarItem.appearance().titlePositionAdjustment = UIOffsetMake(0.0, -2.0)
  }
  
  private func setupNotification() {
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  private func setupTCPSessionManager() {
    ZKJSTCPSessionManager.sharedInstance().delegate = self
  }
  
  
  // MARK: - TCPSessionManagerDelegate
  func didOpenTCPSocket() {
    // 端口连接后发登陆包
    let userID = AccountManager.sharedInstance().userID
    let userName = AccountManager.sharedInstance().userName
    let deviceToken = AccountManager.sharedInstance().deviceToken
    let shopID = AccountManager.sharedInstance().shopID
    let beaconLocationIDs = AccountManager.sharedInstance().beaconLocationIDs
    if !userID.isEmpty {
      ZKJSTCPSessionManager.sharedInstance().loginWithUserID(userID,
        userName: userName,
        deviceToken: deviceToken,
        shopID: shopID,
        beaconLocationIDs: beaconLocationIDs)
    }
  }
  
  func didReceivePacket(dictionary: [NSObject : AnyObject]!) {

  }
  
}

