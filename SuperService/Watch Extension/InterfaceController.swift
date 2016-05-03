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
  @IBOutlet var orderTitleLabel: WKInterfaceLabel!
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
  
  @IBOutlet var btnViewDetail: WKInterfaceButton!
  
  private var currentImageUrl:String = ""
  
  private var arrivalInfo:[String:AnyObject]?
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here.
    alertLabel.setText("暂无到店客人")
    orderGroup.setHidden(true)
    orderTitleLabel.setText("")

  }
  
  func documentDirectory() -> NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
  }
  
  func userImage(userID:String) {
    let path = documentDirectory().stringByAppendingPathComponent(userID)
    let image = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? UIImage
    self.avatarImage.setImage(image)
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    alertLabel.setText("正在加载中...")
    if let extra = NSUserDefaults.standardUserDefaults().objectForKey(ArrivalInfoKey) as? [String: AnyObject] {
      print("willActivate:\(extra)")
      setupViewWithInfo(extra)
    } else {
      print("no extra data")
      alertLabel.setText("暂无到店客人")
      avatarImage.setImageNamed(nil)
      orderGroup.setHidden(true)
      orderTitleLabel.setText("")
      btnViewDetail.setHidden(true)
    }
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
    print("handleActionWithIdentifier(\(identifier)):\(remoteNotification)")
    
    //if let action = identifier where action == "checkDetail" {
      if let extra = remoteNotification["aps"] as? [String: AnyObject] {
        setupViewWithInfo(extra)
      }
    //}
  }
  
  func setupViewWithInfo(arrivalInfo: [String: AnyObject]) {
    print("setupViewWithInfo:\(arrivalInfo)")
    self.arrivalInfo = arrivalInfo
    
    if let date = arrivalInfo["timestamp"] as? NSDate where fabs(date.timeIntervalSinceNow) > 600 {
      alertLabel.setText("暂无到店客人")
      avatarImage.setImageNamed("default_logo")
      return
    }
    
    if let alert = arrivalInfo["alert"] as? String {
      alertLabel.setText(alert)
    } else if let alert = arrivalInfo["alert"] as? NSDictionary,let body = alert["body"] as? String {
      alertLabel.setText(body)
    }
    
    if let userimage = arrivalInfo["userimage"] as? String {
      if currentImageUrl != userimage {
        avatarImage.setImageNamed("default_logo")
      }
      currentImageUrl = userimage
      //if userimage != currentImageUrl {
      avatarImage.setImageWithUrl(userimage.fullImageUrl, placeHolder:nil, completion:nil)
      //}
      //currentImageUrl = userimage
    } else {
      avatarImage.setImageNamed("default_logo")
    }
    
    if let _ = arrivalInfo["tags"] as? NSArray {
      btnViewDetail.setHidden(false)
    } else {
      btnViewDetail.setHidden(true)
    }
   /* // 用户头像
    if let userID = arrivalInfo["userid"] {
      self.userImage(userID as! String)
//      if let url = NSURL(string: "http://svip02.oss-cn-shenzhen.aliyuncs.com/uploads/users/\(userID).jpg") {
        imageRequest(userID as! String)
      }
    
    // 到店信息
    if let username = arrivalInfo["username"] as? String,
      let locdesc = arrivalInfo["locdesc"] as? String {
        alertLabel.setText("\(username) 到达 \(locdesc)")
    }
    
    // 订单信息
    if let order = arrivalInfo["order"] as? [String: AnyObject] {
      if order.count == 0 {
        orderGroup.setHidden(true)
        orderTitleLabel.setText("暂无订单")
        return
      } else {
        orderGroup.setHidden(false)
      }
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
    } else {
      // 无订单
      orderGroup.setHidden(true)
    }
*/
  }
  
//  @IBAction func openParentApp() {
//    print("openParentApp")
//    updateUserActivity(sharedUserActivityType, userInfo: [sharedIdentifierKey : 123456], webpageURL: nil)
//  }
  
  override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
    return self.arrivalInfo
  }
  
}
