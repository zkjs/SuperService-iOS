//
//  PaymentListItem.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct PaymentListItem {
  
  let userid:String
  let username:String
  let userimage:String
  let createtime:String
  let amount:Double  // 注意：单位是分
  let orderno:String
  let paymentno:String
  let status:Int
  let statusdesc:String
  let confirmtime:String
  var displayAmount:String {
    return (Double(amount) / 100).format(".2")
  }
  
  init(userid:String,
    username:String,
    userimage:String,
    createtime:String,
    amount:Double,
    orderno:String,
    paymentno:String,
    status:Int,
    statusdesc:String,
    confirmtime:String
    ) {
      self.userid = userid
      self.username = username
      self.userimage = userimage
      self.createtime = createtime
      self.amount = amount
      self.orderno = orderno
      self.paymentno = paymentno
      self.status = status
      self.statusdesc = statusdesc
      self.confirmtime = confirmtime      
  }
  
  init(json:JSON) {
    userid = json["userid"].string ?? ""
    username = json["username"].string ?? ""
    userimage = json["userimage"].string.map{ $0.isEmpty ? "" : kImageURL + $0 } ?? ""
    createtime = json["createtime"].string ?? ""
    amount = json["amount"].double ?? 0
    orderno = json["orderno"].string ?? ""
    paymentno = json["paymentno"].string ?? ""
    status = json["status"].int ?? 0
    statusdesc = json["statusdesc"].string ?? ""
    confirmtime = json["confirmtime"].string ?? ""
  }
}