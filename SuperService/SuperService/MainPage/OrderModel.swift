//
//  OrderModel.swift
//  SuperService
//
//  Created by admin on 15/10/26.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

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

// pay_status 支付状态 0未支付,1已支付,3支付一部分,4已退款, 5已挂账   int
enum PayStatus: Int {
  case Unpaid = 0
  case Paid = 1
  case PayPartial = 3
  case Refund = 4
  case OnAccount = 5
}

class OrderModel: NSObject {
  
  var arrival_date: String?
  var departure_date: String?
  var fullname: String?
  var created: String?
  var guest: String?
  var guesttel: String?
  var nologin: String?
  var pay_id: String?
  var pay_name: String?
  var pay_status: Int?
  var reservation_no: String?
  var room_rate: String?
  var room_type: String?
  var room_typeid: Int?
  var rooms: String?
  var shopid: Int?
  var status: Int?
  var userid: String?
  
  var duration: Int? {
    get {
      if let arrivalDate = arrival_date, let departureDate = departure_date {
        let days = NSDate.daysFromDateString(arrivalDate, toDateString: departureDate)
        if days == 0 {
          // 当天走也算一天
          return 1
        }
        return days
      } else {
        return nil
      }
    }
  }
  
  var arrivalDateShortStyle: String? {
    get {
      if let arrivalDateString = arrival_date {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let arrivalDate = dateFormatter.dateFromString(arrivalDateString)!
        dateFormatter.dateFormat = "M/dd"
        return dateFormatter.stringFromDate(arrivalDate)
      } else {
        return nil
      }
    }
  }
  
  var orderStatus: String? {
    get {
      guard let status = status else { return "未知状态" }
      if let orderEnum = OrderStatus(rawValue: status) {
        switch orderEnum {
        case .Pending:
          return "未确定"
        case .Canceled:
          return "已取消"
        case .Confirmed:
          return "已确定"
        case .Finised:
          return "已完成"
        case .Checkin:
          return "已入住"
        case .Deleted:
          return "已删除"
        }
      } else {
        return "未知状态"
      }
    }
  }
  
  var payStatus: String? {
    get {
      guard let status = pay_status else { return "未知状态" }
      if let payEnum = PayStatus(rawValue: status) {
        switch payEnum {
        case .Unpaid:
          return "未支付"
        case .Paid:
          return "已支付"
        case .PayPartial:
          return "已支付一部分"
        case .Refund:
          return "已退款"
        case .OnAccount:
          return "已挂帐"
        }
      } else {
        return "未知状态"
      }
    }
  }
  
  init(dic:[String:AnyObject]) {
    arrival_date = dic["arrival_date"] as? String
    departure_date = dic["departure_date"] as? String
    departure_date = dic["departure_date"] as? String
    fullname = dic["fullname"] as? String
    created = dic["created"] as? String
    guest = dic["guest"] as? String
    guesttel = dic["guesttel"] as? String
    nologin = dic["nologin"] as? String
    pay_id = dic["pay_id"] as? String
    pay_name = dic["pay_name"] as? String
    reservation_no = dic["reservation_no"] as? String
    pay_status = dic["pay_status"] as? Int
    room_rate = dic["room_rate"] as? String
    room_type = dic["room_type"] as? String
    room_typeid = dic["room_typeid"] as? Int
    rooms = dic["rooms"] as? String
    shopid = dic["shopid"] as? Int
    status = dic["status"] as? Int
    userid = dic["userid"] as? String
  }

}
