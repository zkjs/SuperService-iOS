//
//  OrderModel.swift
//  SuperService
//
//  Created by admin on 15/10/26.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit


class OrderModel: NSObject {
  
  var arrivaldate: String!
  var company: String!
  var doublebreakfeast: NSNumber!
  var imgurl: String!
  var isinvoice: NSNumber!
  var leavedate: String!
  var nosmoking: NSNumber!
  var orderedby: String!
  var orderno: String!
  var orderstatus: String!
  var paytype: NSNumber!
  var personcount: String!
  var productid: String!
  var remark: String!
  var roomcount: NSNumber!
  var roomno: String!
  var roomprice: double_t!
  var roomtype: String!
  var saleid: String!
  var shopid: String!
  var shopname: String!
  var telephone: String!
  var userid: String!
  var username: String!
  var priviledgename: String!
  var duration: NSNumber? {
    get {
      if let arrivalDate = arrivaldate, let departureDate = leavedate {
        let days = NSDate.ZKJS_daysFromDateString(arrivalDate, toDateString: departureDate)
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
      if let arrivalDateString = arrivaldate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
      if let departureDateString = leavedate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let departureDate = dateFormatter.dateFromString(departureDateString)!
        dateFormatter.dateFormat = "M/dd"
        return dateFormatter.stringFromDate(departureDate)
      } else {
        return nil
      }
    }
  }
  
  var roomInfo: String {
    get {
      if let arrivalDateShortStyle = arrivalDateShortStyle,
         let duration = duration,
         let room_type = roomtype {
        return "\(room_type) | \(arrivalDateShortStyle) | \(duration.integerValue)晚"
      } else {
        return ""
      }
    }
  }
  
//  override var description: String {
//    var output = "arrival_date: \(arrival_date)\n"
//    output += "departure_date: \(departure_date)\n"
//    output += "fullname: \(fullname)\n"
//    output += "created: \(created)\n"
//    output += "guest: \(guest)\n"
//    output += "guesttel: \(guesttel)\n"
//    output += "nologin: \(nologin)\n"
//    output += "pay_id: \(pay_id)\n"
//    output += "pay_name: \(pay_name)\n"
//    output += "reservation_no: \(reservation_no)\n"
//    output += "pay_status: \(pay_status)\n"
//    output += "room_rate: \(room_rate)\n"
//    output += "room_type: \(room_type)\n"
//    output += "room_typeid: \(room_typeid)\n"
//    output += "rooms: \(rooms)\n"
//    output += "shopid: \(shopid)\n"
//    output += "status: \(status)\n"
//    output += "userid: \(userid)\n"
//    output += "duration: \(duration)\n"
//    output += "arrivalDateShortStyle: \(arrivalDateShortStyle)\n"
//    output += "departureDateShortStyle: \(departureDateShortStyle)\n"
//    output += "orderStatus: \(orderStatus)\n"
//    output += "payStatus: \(payStatus)\n"
//    output += "remark: \(remark)\n"
//    return output
//  }
  
  override init() {
    super.init()
    
  }
  
  init(dic:[String:AnyObject]) {
    super.init()
    self.initWithDictionary(dic)
  }
  
  init(json: String) {
    super.init()
    if let dictionary = ZKJSTool.convertJSONStringToDictionary(json) as? [String: AnyObject] {
      initWithDictionary(dictionary)
    }
  }
  
  func initWithDictionary(dic: [String: AnyObject]) {
    arrivaldate = dic["arrivaldate"] as? String ?? ""
    company = dic["company"] as? String ?? ""
    doublebreakfeast = dic["doublebreakfeast"] as? NSNumber ?? NSNumber(double: 0.0)
    imgurl = dic["imgurl"] as? String ?? ""
    isinvoice = dic["isinvoice"] as? NSNumber ?? NSNumber(double: 0.0)
    leavedate = dic["leavedate"] as? String ?? ""
    nosmoking = dic["nosmoking"] as? NSNumber ?? NSNumber(double: 0.0)
    orderedby = dic["orderedby"] as? String ?? ""
    orderno = dic["orderno"] as? String ?? ""
    orderstatus = dic["orderstatus"] as? String ?? ""
    paytype = dic["paytype"] as? NSNumber ?? NSNumber(double: 0.0)
    personcount = dic["personcount"] as? String ?? ""
    remark = dic["remark"] as? String ?? ""
    roomcount = dic["roomcount"] as? NSNumber ?? NSNumber(double: 0.0)
    roomno = dic["roomno"] as? String ?? ""
    roomprice = dic["roomprice"] as? double_t ?? double_t(0.0)
    roomtype = dic["roomtype"] as? String ?? ""
    saleid = dic["saleid"] as? String ?? ""
    shopid = dic["shopid"] as? String ?? ""
    shopname = dic["shopname"] as? String ?? ""
    telephone = dic["telephone"] as? String ?? ""
    userid = dic["userid"] as? String ?? ""
    username = dic["username"] as? String ?? ""
    priviledgename = dic["priviledgename"] as? String ?? ""
  }

}
