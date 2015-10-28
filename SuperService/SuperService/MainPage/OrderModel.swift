//
//  OrderModel.swift
//  SuperService
//
//  Created by admin on 15/10/26.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class OrderModel: NSObject {
  var arrival_date:String?
  var departure_date:String?
  var fullname:String?
  var created:String?
  var guest:String?
  var guesttel:String?
  var nologin:String?
  var pay_id:String?
  var pay_name:String?
  var pay_status:String?
  var reservation_no:String?
  var room_rate:String?
  var room_type:String?
  var room_typeid:Int16?
  var rooms:String?
  var shopid:Int16?
  var status:Int16?
  var userid:String?
  
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
    pay_status = dic["pay_status"] as? String
    room_rate = dic["room_rate"] as? String
    room_type = dic["room_type"] as? String
    room_typeid = dic["room_typeid"] as? Int16
    rooms = dic["rooms"] as? String
    shopid = dic["shopid"] as? Int16
    status = dic["status"] as? Int16
    userid = dic["userid"] as? String
    
  }

}
