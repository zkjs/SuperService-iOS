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
  var sex: String?
  var phone: String?
  var city: String?
  var shopid: String?
  var shopname: String?
  var arrivetime: String?
  var orders: [String:AnyObject]?
  
  override init() {
    super.init()
    
  }
  
   init(dic:JSON){
     locid = dic["locid"].string ?? ""
     userid = dic["userid"].string ?? ""
     username = dic["username"].string ?? ""
    userlevel = dic["userlevel"].string ?? ""
    sex = dic["sex"].string ?? ""
    phone = dic["phone"].string ?? ""
    city =  dic["city"].string ?? ""
    shopid = dic["shopid"].string ?? ""
    shopname  = dic["shopname"].string ?? ""
    arrivetime = dic["arrivatetime"].string ?? ""
    if let orderArr = dic["orders"].array {
      for order in orderArr {
        
      }
    }
    
  }
}
