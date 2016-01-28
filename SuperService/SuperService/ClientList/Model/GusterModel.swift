//
//  GusterModel.swift
//  SuperService
//
//  Created by AlexBang on 16/1/27.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class GusterModel: NSObject {
  var userid: String?
  var username: String?
  var sex: String?
  var phone: String?
  var position: String?
  var set: Bool?
  var is_bd: Bool?
  var salesname: String?
  var salesid: String?
  
  override init() {
    super.init()
    
  }
  
  init(dic:[String: AnyObject]){
    
    if let userID = dic["userid"] as? String {
      userid = userID
    } else if let userID = dic["userid"] as? NSNumber {
      userid = userID.stringValue
    }
   
    
    if let name = dic["username"] as? String {
      username = name
    } else if let name = dic["username"] as? NSNumber {
      username = name.stringValue
    }
    if let phoneNumber = dic["phone"] as? NSNumber {
      phone = phoneNumber.stringValue
    } else if let phoneNumber = dic["phone"] as? String {
      phone = phoneNumber
    }
    
    sex = dic["sex"] as? String ?? ""
    position = dic["position"] as? String ?? ""
    set = dic["set"] as?Bool
    is_bd = dic["is_bd"] as?Bool
    salesname = dic["salesname"] as? String ?? ""
    salesid = dic["salesid"] as? String ?? ""
    
  }

}
