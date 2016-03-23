//
//  CustomerOrder.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

class CustomerOrder {
  let orderNO:String
  let room:String
  let duration:String
  let indate:String
  
  init(orderNO:String,
    room:String,
    duration:String,
    indate:String
    ) {
      self.orderNO = orderNO
      self.room = room
      self.duration = duration
      self.indate = indate
  }
  
  init(json:JSON) {
    orderNO = json["orderno"].string ?? ""
    room = json["room"].string ?? ""
    duration = json["duration"].string ?? ""
    indate = json["indate"].string ?? ""
  }
  init(json:NSDictionary) {
    orderNO = json["orderno"] as? String ?? ""
    room = json["room"] as? String ?? ""
    duration = json["duration"] as? String ?? ""
    indate = json["indate"] as? String ?? ""
  }
}