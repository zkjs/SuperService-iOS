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
    userimage = data["userimage"].string ?? ""
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
  
  init(data:NSDictionary) {
    locid = data["locid"] as? String ?? ""
    userid = data["userid"] as? String ?? ""
    username = data["username"] as? String ?? ""
    viplevel = data["viplevel"] as? Int ?? 0
    userimage = data["userimage"] as? String ?? ""
    sex = data["sex"] as? Int ?? 0
    phone = data["phone"] as? String ?? ""
    city = data["city"] as? String ?? ""
    shopid = data["shopid"] as? String ?? ""
    shopName = data["shopname"] as? String ?? ""
    arrivetime = data["arrivetime"] as? String ?? ""
    
    if let ordersData = data["orders"] as? NSArray where ordersData.count > 0 {
      var ordersArray = [CustomerOrder]()
      for o in ordersData {
        let order = CustomerOrder(json: o as! NSDictionary)
        ordersArray.append(order)
      }
      orders = ordersArray
    } else {
      orders = nil
    }

  }
}