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
      // 姓名
      if let title = aps["alert"] as? String {
        nameLabel.setText(title)
      }
      
      // 用户头像
      if let userimage = aps["userimage"] as? String {
        //imageRequest(url)
        avatarImage.setImageWithUrl(userimage.fullImageUrl, placeHolder:UIImage(named: "default_logo"))
      }
      
      // Cache ArrivalInfo Notification
      NSUserDefaults.standardUserDefaults().setObject(aps, forKey: ArrivalInfoKey)
    }
  }
  
  func documentDirectory() -> NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
  }
  
  /*func userImage(userID:String) {
    let path = documentDirectory().stringByAppendingPathComponent(userID)
    let image = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? UIImage
    self.avatarImage.setImage(image)
  }*/
  
}
