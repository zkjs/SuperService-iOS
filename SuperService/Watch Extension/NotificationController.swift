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
  @IBOutlet var orderStatus: WKInterfaceLabel!
  
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
//    var extra  = NSDictionary()
        if let c = remoteNotification["aps"] as? NSDictionary,let Extra = c["message"] as? NSDictionary,let extra = Extra["data"] as? NSDictionary {
      // 用户头像
      if let userid = extra["userid"] as? String {
        self.userImage(userid)
      }
      if let userimage = extra["userImage"] as? String {
        if let url = NSURL(string: "http://svip02.oss-cn-shenzhen.aliyuncs.com/\(userimage)") {
          imageRequest(url)
        }
      }
      // 姓名
      if let username = extra["username"] as? String {
        nameLabel.setText(username)
      }
      if let order = extra["title"] as? [String: AnyObject] {
        // 内容
        if let room_type = order["content"] as? String {
          roomTypeLabel.setText(room_type)
        }
        // 预计到达时间
        if let duration = order["arrivalTime"] as? NSNumber {
          durationLabel.setText("\(duration.stringValue)晚")
        }
      }
      
      // Cache ArrivalInfo Notification
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
  
  func documentDirectory() -> NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
  }
  
  func userImage(userID:String) {
    let path = documentDirectory().stringByAppendingPathComponent(userID)
    let image = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? UIImage
    self.avatarImage.setImage(image)
  }
  
}
