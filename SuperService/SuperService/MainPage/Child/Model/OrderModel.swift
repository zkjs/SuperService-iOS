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
  var guesttel: NSNumber?
  var nologin: NSNumber?
  var pay_id: NSNumber?
  var pay_name: String?
  var pay_status: NSNumber?
  var reservation_no: String?
  var room_rate: NSNumber?
  var room_type: String?
  var room_typeid: NSNumber?
  var rooms: NSNumber?
  var shopid: NSNumber?
  var status: NSNumber?
  var userid: String?
  var remark: String?
  var imgurl: String?
  
//  users 多维[入住人] 必须是已保存用户
//  简化模式:入住人id,入住人id,入住人id...
//  invoice [发票信息] 必须是已保存发票
//  格式:
//  invoice[invoice_title]=  发票抬头
//  invoice[invoice_get_id]=1 取票方式 1到店自取,2邮寄(目前不能用)
//  privilege   商家特权 必须是级别够的特权 有没有权限自己根据代码要求和用户等级\用户会员等级判断
//  简化模式:特权id,特权id,特权id,...
//  room_tags [房间选项] 英文逗号隔开中文标签
//  格式 大床,安静,无烟
  var users: String?
  var invoice: String?
  var privilege: String?
  var room_tags: String?
  
  var duration: NSNumber? {
    get {
      if let arrivalDate = arrival_date, let departureDate = departure_date {
        let days = NSDate.daysFromDateString(arrivalDate, toDateString: departureDate)
        if days == 0 {
          // 当天走也算一天
          return NSNumber(integer: 1)
        }
        return NSNumber(integer: days)
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
  
  var departureDateShortStyle: String? {
    get {
      if let departureDateString = departure_date {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let departureDate = dateFormatter.dateFromString(departureDateString)!
        dateFormatter.dateFormat = "M/dd"
        return dateFormatter.stringFromDate(departureDate)
      } else {
        return nil
      }
    }
  }
  
  var orderStatus: String? {
    get {
      guard let status = status else { return "未知状态" }
      if let orderEnum = OrderStatus(rawValue: status.integerValue) {
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
      if let payEnum = PayStatus(rawValue: status.integerValue) {
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
  
  override var description: String {
    var output = "arrival_date: \(arrival_date)\n"
    output += "departure_date: \(departure_date)\n"
    output += "fullname: \(fullname)\n"
    output += "created: \(created)\n"
    output += "guest: \(guest)\n"
    output += "guesttel: \(guesttel)\n"
    output += "nologin: \(nologin)\n"
    output += "pay_id: \(pay_id)\n"
    output += "pay_name: \(pay_name)\n"
    output += "reservation_no: \(reservation_no)\n"
    output += "pay_status: \(pay_status)\n"
    output += "room_rate: \(room_rate)\n"
    output += "room_type: \(room_type)\n"
    output += "room_typeid: \(room_typeid)\n"
    output += "rooms: \(rooms)\n"
    output += "shopid: \(shopid)\n"
    output += "status: \(status)\n"
    output += "userid: \(userid)\n"
    output += "duration: \(duration)\n"
    output += "arrivalDateShortStyle: \(arrivalDateShortStyle)\n"
    output += "departureDateShortStyle: \(departureDateShortStyle)\n"
    output += "orderStatus: \(orderStatus)\n"
    output += "payStatus: \(payStatus)\n"
    output += "remark: \(remark)\n"
    return output
  }
  
  override init() {
    super.init()
    
  }
  
  init(dic:[String:AnyObject]) {
    arrival_date = dic["arrival_date"] as? String
    departure_date = dic["departure_date"] as? String
    fullname = dic["fullname"] as? String
    created = dic["created"] as? String
    guest = dic["guest"] as? String
    guesttel = dic["guesttel"] as? NSNumber
    nologin = dic["nologin"] as? NSNumber
    pay_id = dic["pay_id"] as? NSNumber
    pay_name = dic["pay_name"] as? String
    reservation_no = dic["reservation_no"] as? String
    pay_status = dic["pay_status"] as? NSNumber
    room_rate = dic["room_rate"] as? NSNumber
    room_type = dic["room_type"] as? String
    room_typeid = dic["room_typeid"] as? NSNumber
    rooms = dic["rooms"] as? NSNumber
    shopid = dic["shopid"] as? NSNumber
    status = dic["status"] as? NSNumber
    userid = dic["userid"] as? String
    remark = dic["remark"] as? String
  }

}
