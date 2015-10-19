//
//  Order.swift
//  SuperService
//
//  Created by Hanton on 10/19/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

//{
//  "arrival_date" = "2015-10-17";
//  created = "2015-10-17 05:13:01";
//  "departure_date" = "2015-10-18";
//  fullname = "\U957f\U6c99\U8c6a\U5ef7\U5927\U9152\U5e97";
//  guest = "<null>";
//  guestid = 5603d8d417392;
//  guesttel = "<null>";
//  imgurl = "uploads/rooms/1.jpg";
//  "pay_id" = 1;
//  "pay_name" = "\U652f\U4ed8\U5b9d";
//  "pay_status" = 0;
//  payment = 1;
//  remark = "<null>";
//  "reservation_no" = H20151017051301;
//  "room_rate" = 566;
//  "room_type" = "\U8c6a\U534e\U5927\U5e8a\U65e0\U65e9";
//  "room_typeid" = 1;
//  rooms = 1;
//  shopid = 120;
//  status = 0;
//};

class Order: NSObject {

  var roomCount: NSNumber = 0
  var paymentType: NSNumber = 0
  var clientPhone: NSNumber = 0
  var roomID: NSNumber = 0
  var paymentStatus: NSNumber = 0
  var status: NSNumber = 0
  var roomRate: NSNumber = 0
  var shopID: NSNumber = 0
  var paymentID: NSNumber = 0
  var arrivalDate = ""
  var createdDate = ""
  var roomImage = ""
  var departureDate = ""
  var clientID = ""
  var shopName = ""
  var clientName = ""
  var remark = ""
  var paymentName = ""
  var roomType = ""
  var orderNO = ""
  
  // 自定义
  var duration: NSNumber = 0
  
  init(dict: [String: AnyObject]) {
    if let rooms = dict["rooms"] as? NSNumber {
      self.roomCount = rooms
    }
    if let payment = dict["payment"] as? NSNumber {
      self.paymentType = payment
    }
    if let guesttel = dict["guesttel"] as? NSNumber {
      self.clientPhone = guesttel
    }
    if let room_typeid = dict["room_typeid"] as? NSNumber {
      self.roomID = room_typeid
    }
    if let pay_status = dict["pay_status"] as? NSNumber {
      self.paymentStatus = pay_status
    }
    if let status = dict["status"] as? NSNumber {
      self.status = status
    }
    if let room_rate = dict["room_rate"] as? NSNumber {
      self.roomRate = room_rate
    }
    if let shopid = dict["shopid"] as? NSNumber {
      self.shopID = shopid
    }
    if let pay_id = dict["pay_id"] as? NSNumber {
      self.paymentID = pay_id
    }
    if let arrival_date = dict["arrival_date"] as? String {
      self.arrivalDate = arrival_date
    }
    if let created = dict["created"] as? String {
      self.createdDate = created
    }
    if let imgurl = dict["imgurl"] as? String {
      self.roomImage = imgurl
    }
    if let departure_date = dict["departure_date"] as? String {
      self.departureDate = departure_date
    }
    if let guestid = dict["guestid"] as? String {
      self.clientID = guestid
    }
    if let fullname = dict["fullname"] as? String {
      self.shopName = fullname
    }
    if let guest = dict["guest"] as? String {
      self.clientName = guest
    }
    if let remark = dict["remark"] as? String {
      self.remark = remark
    }
    if let pay_name = dict["pay_name"] as? String {
      self.paymentName = pay_name
    }
    if let room_type = dict["room_type"] as? String {
      self.roomType = room_type
    }
    if let reservation_no = dict["reservation_no"] as? String {
      self.orderNO = reservation_no
    }
  }
  
}
