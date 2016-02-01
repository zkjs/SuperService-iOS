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
  @IBOutlet var roomTypeLabel: WKInterfaceLabel!
  @IBOutlet var durationLabel: WKInterfaceLabel!
  @IBOutlet var locationLabel: WKInterfaceLabel!
  
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
          let array = body.componentsSeparatedByString(" ")
          nameLabel.setText(array[0])
          locationLabel.setText("已到达\(array[2])")
        }
      }
    }
    
    // Cache ArrivalInfo Notification
    if let extra = remoteNotification["extra"] as? [String: AnyObject] {
      if let order = extra["order"] as? [String: AnyObject] {
        // 房型
        if let room_type = order["room_type"] as? String {
          roomTypeLabel.setText(room_type)
        }
        // 天数
        if let duration = order["dayInt"] as? NSNumber {
          durationLabel.setText("\(duration.stringValue)晚")
        }
      }
      
      if let userid = extra["userid"] as? String {
        // 用户头像
        if let url = NSURL(string: "http://svip02.oss-cn-shenzhen.aliyuncs.com/uploads/users/\(userid).jpg") {
          imageRequest(url)
        }
      }
      NSUserDefaults.standardUserDefaults().setObject(extra, forKey: ArrivalInfoKey)
    }
    completionHandler(.Custom)
  }
  
  func imageRequest(url:NSURL) {
    let requestURL: NSURL = url
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(urlRequest) {
      (data, response, error) -> Void in
      if error == nil {
        self.avatarImage.setImage(UIImage(data:data!))
      } else {
        print(error)
      }
    }
    task.resume()
  }
  
}
