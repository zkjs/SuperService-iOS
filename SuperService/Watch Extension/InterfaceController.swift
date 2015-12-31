//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Hanton on 12/29/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import WatchKit
import Foundation


//let sharedUserActivityType = "com.zkjinshi.SuperService.WatchOpenApp"
//let sharedIdentifierKey = "identifier"
// http://doc.zkjinshi.com/index.php?action=artikel&cat=17&id=67&artlang=zh&highlight=pay_status
// status 订单状态 默认0可取消订单 1已取消订单 2已确认订单 3已经完成的订单 4正在入住中 5已删除订单 int
enum OrderStatus: Int {
  case Pending = 0
  case Canceled = 1
  case Confirmed = 2
  case Finised = 3
  case Checkin = 4
  case Deleted = 5
}

class InterfaceController: WKInterfaceController {
  
  @IBOutlet var avatarImage: WKInterfaceImage!
  @IBOutlet var alertLabel: WKInterfaceLabel!
  @IBOutlet var orderGroup: WKInterfaceGroup!
  @IBOutlet var orderNOLabel: WKInterfaceLabel!
  @IBOutlet var shopNameLabel: WKInterfaceLabel!
  @IBOutlet var orderStatusLabel: WKInterfaceLabel!
  @IBOutlet var arrivalDateLabel: WKInterfaceLabel!
  @IBOutlet var daysLabel: WKInterfaceLabel!
  @IBOutlet var guestLabel: WKInterfaceLabel!
  @IBOutlet var roomTypeLabel: WKInterfaceLabel!
  @IBOutlet var roomsLabel: WKInterfaceLabel!
  @IBOutlet var roomRateLabel: WKInterfaceLabel!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here.
    alertLabel.setText("")
    orderGroup.setHidden(true)
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
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
    
    print(remoteNotification)
    
    if let action = identifier {
      if action == "checkDetail" {
        if let extra = remoteNotification["extra"] as? [String: AnyObject] {
          // 用户头像
          if let userID = extra["userid"] {
            if let url = NSURL(string: "http://tap.zkjinshi.com/uploads/users/\(userID).jpg") {
              imageRequest(url)
            }
          }
          
          // 到店信息
          if let username = extra["username"] as? String,
             let locdesc = extra["locdesc"] as? String {
            alertLabel.setText("\(username) 到达 \(locdesc)")
          }
          
          // 订单信息
          if let order = extra["order"] as? [String: AnyObject] {
            orderGroup.setHidden(false)
            if let reservation_no = order["reservation_no"] as? String {
              orderNOLabel.setText(reservation_no)
            }
            if let fullname = order["fullname"] as? String {
              shopNameLabel.setText(fullname)
            }
            if let status = order["status"] as? NSNumber {
              if let orderEnum = OrderStatus(rawValue: status.integerValue) {
                var statusString = ""
                switch orderEnum {
                case .Pending:
                  statusString = "待确定"
                case .Canceled:
                  statusString = "已取消"
                case .Confirmed:
                  statusString = "已确定"
                case .Finised:
                  statusString = "已完成"
                case .Checkin:
                  statusString = "已入住"
                case .Deleted:
                  statusString = "已删除"
                }
                orderStatusLabel.setText(statusString)
              }
            }
            if let arrival_date = order["arrival_date"] as? String {
              arrivalDateLabel.setText(arrival_date)
            }
            if let dayInt = order["dayInt"] as? NSNumber {
              daysLabel.setText(dayInt.stringValue)
            }
            if let guest = order["guest"] as? String {
              guestLabel.setText(guest)
            }
            if let room_type = order["room_type"] as? String {
              roomTypeLabel.setText(room_type)
            }
            if let rooms = order["rooms"] as? NSNumber {
              roomsLabel.setText(rooms.stringValue)
            }
            if let room_rate = order["room_rate"] as? NSNumber {
              roomRateLabel.setText(room_rate.stringValue)
            }
          }
        }
      }
    }
  }
  
//  @IBAction func openParentApp() {
//    print("openParentApp")
//    updateUserActivity(sharedUserActivityType, userInfo: [sharedIdentifierKey : 123456], webpageURL: nil)
//  }
  
}
