//
//  HttpService+FacePay.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension HttpService {
  
  private enum ResourcePathFacePay: CustomStringConvertible {
    case NearbyCustomers(shopid:String, locids:String)
    case Payment
    case PaymentList
    case SearchUserByPhone
    
    var description: String {
      switch self {
      case .NearbyCustomers(let shopid,let locids): return "/pyx/lbs/v1/loc/beacon/\(shopid)/\(locids)"
      case .Payment:            return "/for/res/v1/payment"
      case .PaymentList:        return "/for/res/v1/payment/ss"
      case .SearchUserByPhone:  return "/for/res/v1/query/user/all?phone="
      }
    }
  }
  
  
  static func getNearbyCustomers(shopid shopid:String,locids:String,completionHandler:([NearbyCustomer]?,NSError?) -> ()) {
    let urlString = ResourcePathFacePay.NearbyCustomers(shopid: shopid, locids: locids).description.fullUrl
    
    let dict = ["page":"0","page_size":"40"]
    
    get(urlString, parameters: dict) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array where data.count > 0 {
          var users = [NearbyCustomer]()
          for userData in data {
            let user = NearbyCustomer(data: userData)
            users.append(user)
          }
          print(users.count)
          completionHandler(users,nil)
        }
      }
    }
  }
  
  static func chargeCustomer(amount:Double, userid:String, orderNo:String?, completionHandler:(String?,NSError?) -> Void) {
    let urlString =  ResourcePathFacePay.Payment.description.fullUrl
    var dict = ["amount":"\(Int(amount*100))","target":userid]
    if let orderNo = orderNo {
      dict["orderno"] = orderNo
    }
    
    post(urlString, parameters: dict) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let orderno = json?["orderno"].string {
          completionHandler(orderno,nil)
        }
      }
    }
  }
  
  static func searchUserByPhone(phone:String,completionHandler:(JSON?,NSError?) -> Void) {
    let urlString = (ResourcePathFacePay.SearchUserByPhone.description + "\(phone)").fullUrl
//    let dict = ["phone":phone]
    get(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
       completionHandler(json,error)
      }
    }
  }
  
  static func getPaymentList(page:Int = 0, pageSize:Int = 20, status:Int?, completionHandler:([PaymentListItem]?,NSError?) -> Void) {
    let urlString = ResourcePathFacePay.PaymentList.description.fullUrl
    var dict = ["page":"\(page)","page_size":"\(pageSize)"]
    if let status = status {
      dict["status"] = "\(status)"
    }
    
    get(urlString, parameters: dict) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array where data.count > 0 {
          var results = [PaymentListItem]()
          for d in data {
            let item = PaymentListItem(json: d)
            results.append(item)
          }
          print(results.count)
          completionHandler(results,nil)
        }
      }
    }
  }

}