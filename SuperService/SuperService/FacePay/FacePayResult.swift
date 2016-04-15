//
//  FacePayResult.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

enum PaymentResultType {
  case Sucess
  case Waiting
  case Rejected
}

class FacePayResult {
  let status:Int
  let orderNo:String?
  let paymentNo:String?
  let errorCode:Int
  let waiting:Bool
  let customer:NearbyCustomer
  let amount:Double
  let confirmTime:String?
  let createTime:String?
  
  init(customer:NearbyCustomer,
    amount:Double,
    succ:Int,
    orderNo:String?,
    paymentNo:String?,
    errorCode:Int,
    waiting:Bool,
    confirmTime:String?,
    createTime:String?
    ) {
      self.status = succ
      self.orderNo = orderNo
      self.paymentNo = paymentNo
      self.errorCode = errorCode
      self.waiting = waiting
      self.customer = customer
      self.amount = amount
      self.confirmTime = confirmTime
      self.createTime = createTime
  }
  
//  init(dict:NSDictionary) {
//    self.status = dict["status"] as? Int ?? 0
//    orderNo = dict["orderno"] as? String ?? ""
//    customer
//    
//  }
  
}