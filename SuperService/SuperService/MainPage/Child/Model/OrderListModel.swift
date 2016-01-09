//
//  OrderListModel.swift
//  SVIP
//
//  Created by AlexBang on 15/12/29.
//  Copyright © 2015年 zkjinshi. All rights reserved.
//

import UIKit
/**
 * 订单状态(0:未确认 1:已确认 2:已取消)
 */
class OrderListModel: NSObject {
  var orderno: String!
  var shopid: String!
  var userid: String!
  var shopname: String!
  var shoplogo: String!
  var productid: String!
  var roomno: String!
  var roomcount: NSNumber!
   var orderstatus: String!
  var roomtype: String!
  var roomprice: double_t!
  var orderedby: String!
  var telephone: String!
  var arrivaldate: NSDate!
  var leavedate: NSDate!
  var created: NSDate!
  var saleid:String!
  var username:String!
  var priviledgename: String!
  
  var duration: NSNumber? {
    get {
      if let arrivalDate = arrivaldate, let departureDate = leavedate {
        let days = NSDate.ZKJS_daysFromDate(arrivalDate, toDate: departureDate)
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
      if let arrivalDateString = arrivalDateString {
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
      if let departureDateString = departureDateString {
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
  
  var arrivalDateString: String? {
    get {
      if let arrivalDate = arrivaldate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(arrivalDate)
      } else {
        return nil
      }
    }
  }
  
  var departureDateString: String? {
    get {
      if let departureDate = leavedate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(departureDate)
      } else {
        return nil
      }
    }
  }
  
  var createdDateString: String? {
    get {
      if let createdDate = created {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(createdDate)
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
  
  override init() {
    super.init()
  }
  
  init(dic: NSDictionary) {
    orderno = dic["orderno"] as? String ?? ""
    shopid = dic["shopid"] as? String ?? ""
    userid = dic["userid"] as? String ?? ""
    shopname = dic["shopname"] as? String ?? ""
    shoplogo = dic["shoplogo"] as? String ?? ""
    productid = dic["productid"] as? String ?? ""
    roomno = dic["roomno"] as? String ?? ""
    roomtype = dic["roomtype"] as? String ?? ""
    roomprice = dic["roomprice"] as? double_t ??  double_t(0.0)
    roomcount = dic["roomcount"] as? NSNumber ?? NSNumber(double: 0.0)
    orderstatus = dic["orderstatus"] as? String ?? ""
    orderedby = dic["orderedby"] as? String ?? ""
    telephone = dic["telephone"] as? String ?? ""
    username = dic["username"] as? String ?? ""
    saleid = dic["saleid"] as? String ?? ""
    arrivaldate = dic["arrivaldate"] as? NSDate ?? NSDate()
    leavedate = dic["leavedate"] as? NSDate ?? NSDate()
    created = dic["created"] as? NSDate ?? NSDate()
    priviledgename = dic["priviledgename"] as? String ?? ""
    
  }

}
