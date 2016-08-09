//
//  HttpService+Client.swift
//  SuperService
//
//  Created by Qin Yejun on 8/8/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  
  //客户标签
  func queryUsertags(userid:String,completionHandler: (TagsModel?,NSError?)->Void) {
    let urlString = ResourcePath.QueryUserTags.description.fullUrl
    let param = ["si_id":userid]
    get(urlString, parameters: param) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"]
        {
          let user = TagsModel(dic: data)
          completionHandler(user,nil)
        }
      }
    }
  }
  
  //更新客户标签
  func updataUsertags(userid:String,tags:[Int],completionHandler: (JSON?,NSError?)->Void) {
    let urlString = ResourcePath.UpdateUserTags.description.fullUrl
    let param = ["si_id":userid,"tags":tags]
    post(urlString, parameters: param as? [String : AnyObject]) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  //客户到店列表
  func clientArrivalList(userid:String, page:Int = 0,completionHandler:([ClientArrivalModel]?,NSError?) -> ()) {
    let urlString =  ResourcePath.ClientArriving(uid: userid).description.fullUrl

    get(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json {
          var arrviteArr = [ClientArrivalModel]()
          if let array = data["data"].array {
            for dic in array {
              let arrvite = ClientArrivalModel(dic: dic)
              arrviteArr.append(arrvite)
            }
          }
          completionHandler(arrviteArr,nil)
        }
      }
    }
  }
  
  //客户支付列表
  func clientPaymentList(userid:String, page:Int = 0,completionHandler:([ClientPaymentModel]?,NSError?) -> ()) {
    let urlString =  ResourcePath.ClientPayment(uid: userid).description.fullUrl
    
    get(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json {
          var ret = [ClientPaymentModel]()
          if let array = data["data"].array {
            for dic in array {
              let arrvite = ClientPaymentModel(dic: dic)
              ret.append(arrvite)
            }
          }
          completionHandler(ret,nil)
        }
      }
    }
  }
  
  //添加消费记录
  func addPayment(userid:String, amount: Double, remark: String, completionHandler: (Bool,NSError?)->Void) {
    let urlString = ResourcePath.AddClientPayment.description.fullUrl
    let total = Int(amount * 100)
    let param = ["userid":userid, "amount":total, "remark":remark]
    post(urlString, parameters: param as? [String : AnyObject]) { (json, error) -> Void in
      if let error = error {
        completionHandler(false,error)
      } else {
        completionHandler(true,nil)
      }
    }
  }
  
}

