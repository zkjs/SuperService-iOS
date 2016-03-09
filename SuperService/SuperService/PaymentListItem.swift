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
  let createtime:String
  let amount:Double
  let orderno:String
  let paymentno:String
  let status:Int
  let statusdesc:String
  let confirmtime:String
  
  init(userid:String,
    username:String,
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
    createtime = json["createtime"].string ?? ""
    amount = json["amount"].double ?? 0
    orderno = json["orderno"].string ?? ""
    paymentno = json["paymentno"].string ?? ""
    status = json["status"].int ?? 0
    statusdesc = json["statusdesc"].string ?? ""
    confirmtime = json["confirmtime"].string ?? ""
  }
}