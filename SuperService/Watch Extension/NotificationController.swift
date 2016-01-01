//
//  NotificationController.swift
//  Watch Extension
//
//  Created by Hanton on 12/29/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import WatchKit
import Foundation


let ArrivalInfoKey = "ArrivalInfoKey"


class NotificationController: WKUserNotificationInterfaceController {
  
  @IBOutlet var avatarImage: WKInterfaceImage!
  @IBOutlet var bodyLabel: WKInterfaceLabel!
  
  override init() {
    // Initialize variables here.
    super.init()
    
    // Configure interface objects here.
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
//  override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
//    // This method is called when a local notification needs to be presented.
//    // Implement it if you use a dynamic notification interface.
//    // Populate your dynamic notification interface as quickly as possible.
//    //
//    // After populating your dynamic notification interface call the completion block.
//    completionHandler(.Custom)
//  }
  
  override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    print(remoteNotification)
    if let aps = remoteNotification["aps"] {
      if let alert = aps["alert"] as? [String: AnyObject] {
        if let body = alert["body"] as? String {
          bodyLabel.setText(body)
        }
      }
    }
    
    // Cache ArrivalInfo Notification
    if let extra = remoteNotification["extra"] as? [String: AnyObject] {
      NSUserDefaults.standardUserDefaults().setObject(extra, forKey: ArrivalInfoKey)
    }
    completionHandler(.Custom)
  }
}
