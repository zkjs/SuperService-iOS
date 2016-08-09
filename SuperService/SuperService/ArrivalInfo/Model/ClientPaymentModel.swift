//
//  ClientPaymentModel.swift
//  SuperService
//
//  Created by Qin Yejun on 8/8/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct ClientPaymentModel {
  let amount: Int
  let createtime: String
  let orderno: String
  let remark: String
  let userid: String
  var displayAmount:String {
    return "￥" + (Double(amount)/100.0).format("0.2")
  }
  
  init(dic:JSON){
    amount = dic["amount"].int ?? 0
    createtime = dic["createtime"].string ?? ""
    orderno = dic["orderno"].string ?? ""
    remark = dic["remark"].string ?? ""
    userid = dic["userid"].string ?? ""
  }
}
