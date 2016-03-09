//
//  FacePayResult.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct FacePayResult {
  let success:Bool
  let orderNo:String?
  let errorCode:Int
  let waiting:Bool
  let customer:NearbyCustomer
  let amount:Int
  
  init(customer:NearbyCustomer,
    amount:Int,
    succ:Bool,
    orderNo:String?,
    errorCode:Int,
    waiting:Bool
    ) {
      self.success = succ
      self.orderNo = orderNo
      self.errorCode = errorCode
      self.waiting = waiting
      self.customer = customer
      self.amount = amount
  }
}