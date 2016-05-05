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
  @IBOutlet var nameLabel: WKInterfaceLabel!
  
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
  
  override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    print("remote")
    print(remoteNotification)
    
    updateDisplayWithNotificationUserInfo(remoteNotification)
    
    completionHandler(.Custom)
  }
  
  func updateDisplayWithNotificationUserInfo(userInfo:[NSObject: AnyObject]) {
    if let aps = userInfo["aps"] as? NSDictionary {
      
      let dict = aps.mutableCopy() as! NSMutableDictionary
      dict.setValue(NSDate(), forKey: "timestamp")
      
      // 姓名
      if let title = aps["alert"] as? String {
        nameLabel.setText(title)
      } else if let alert = aps["alert"] as? NSDictionary,let body = alert["body"] as? String {
        nameLabel.setText(body)
      }
      
      var avatgarUrl = ""
      // 用户头像
      if let userimage = aps["userimage"] as? String {
        avatgarUrl = userimage
      } else if let msg = aps["message"] as? NSDictionary,
          let data = msg["data"] as? NSDictionary,
          let userimage = data["userimage"] as? String {
        avatgarUrl = userimage
        dict.setValue(userimage, forKey: "userimage")
      }
      
      if !avatgarUrl.isEmpty {
        avatarImage.setImageWithUrl(avatgarUrl.avatarURL, placeHolder:UIImage(named: "default_logo"),completion:nil)
      }

      // Cache ArrivalInfo Notification
      NSUserDefaults.standardUserDefaults().setObject(dict, forKey: ArrivalInfoKey)
    }
  }
  
  func documentDirectory() -> NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
  }
  
}
