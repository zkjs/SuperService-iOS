//
//  NearbyCustomer.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct NearbyCustomer {
  let locid:String
  let userid:String
  let username:String
  let viplevel:Int
  let userimage:String
  let sex:Int
  let phone:String
  let city:String
  let shopid:String
  let shopName:String
  let arrivetime:String
  let orders:[CustomerOrder]?
  
  init(data:JSON) {
    locid = data["locid"].string ?? ""
    userid = data["userid"].string ?? ""
    username = data["username"].string ?? ""
    viplevel = data["viplevel"].int ?? 0
    userimage = data["userimage"].string.map{ $0.isEmpty ? "" : kImageURL + $0 } ?? ""
    sex = data["sex"].int ?? 0
    phone = data["phone"].string ?? ""
    city = data["city"].string ?? ""
    shopid = data["shopid"].string ?? ""
    shopName = data["shopname"].string ?? ""
    arrivetime = data["arrivetime"].string ?? ""
    
    if let ordersData = data["orders"].array where ordersData.count > 0 {
      var ordersArray = [CustomerOrder]()
      for o in ordersData {
        let order = CustomerOrder(json: o)
        ordersArray.append(order)
      }
      orders = ordersArray
    } else {
      orders = nil
    }
    
  }
}