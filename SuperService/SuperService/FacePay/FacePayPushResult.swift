//
//  FacePayPushResult.swift
//  SuperService
//
//  Created by Qin Yejun on 3/10/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

class FacePayPushResult {
  let paymentno:String
  let amount:Double
  let createtime:String
  let orderno:String
  let salesid:String
  let shopname:String
  let shopid:String
  let statusdesc:String
  let userid:String
  let status:Int
  let username:String
  let custom:NearbyCustomer
  init(json:NSDictionary) {
    paymentno = json["paymentno"] as? String ?? ""
    amount = json["amount"] as? double_t ?? 0.0
    createtime = json["createtime"] as? String ?? ""
    orderno = json["orderno"] as? String ?? ""
    salesid = json["salesid"] as? String ?? ""
    shopname = json["shopname"] as? String ?? ""
    shopid = json["shopid"] as? String ?? ""
    userid = json["userid"] as? String ?? ""
    username = json["username"] as? String ?? ""
    status = json["status"] as? Int ?? 0
    statusdesc = json["statusdesc"] as? String ?? ""
    custom = NearbyCustomer(data: json)
    
  }
  init(json:JSON) {
    paymentno = json["paymentno"].string ?? ""
    amount = json["amount"].double ?? 0
    createtime = json["createtime"].string ?? ""
    orderno = json["orderno"].string ?? ""
    salesid = json["salesid"].string ?? ""
    shopname = json["shopname"].string ?? ""
    shopid = json["shopid"].string ?? ""
    userid = json["userid"].string ?? ""
    username = json["username"].string ?? ""
    status = json["status"].int ?? 0
    statusdesc = json["statusdesc"].string ?? ""
    custom = NearbyCustomer(data: json)
  }
}