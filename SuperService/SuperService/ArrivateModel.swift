//
//  ArrivateModel.swift
//  SuperService
//
//  Created by AlexBang on 16/3/14.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class ArrivateModel: NSObject {
  var locid: String?
  var userid: String?
  var username: String?
  var userlevel: String?
  var sex: Int?
  var phone: String?
  var city: String?
  var locdesc: String?
  var shopid: String?
  var shopname: String?
  var arrivetime: String?
  var orders: [JSON]?
  var duration:String?
  var orderno:String?
  var room:String?
  var indate:String?
  var userimage:String?
  
  override init() {
    super.init()
    
  }
  
   init(dic:JSON){
    locdesc = dic["locdesc"].string ?? ""
    userimage = dic["userimage"].string ?? ""
    locid = dic["locid"].string ?? ""
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
    userlevel = dic["userlevel"].string ?? ""
    sex = dic["sex"].int ?? 0
    phone = dic["phone"].string ?? ""
    city =  dic["city"].string ?? ""
    shopid = dic["shopid"].string ?? ""
    shopname  = dic["shopname"].string ?? ""
    arrivetime = dic["arrivetime"].string ?? ""
    orders = dic["orders"].array
    if let orderArr = dic["orders"].array?.first {
        self.orderno = orderArr["orderno"].string ?? ""
        self.indate = orderArr["indate"].string ?? ""
        self.room = orderArr["room"].string ?? ""
        self.duration = orderArr["duration"].string ?? ""
    }
    
  }
}
