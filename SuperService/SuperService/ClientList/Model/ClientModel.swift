//
//  ClientModel.swift
//  SuperService
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class ClientModel: NSObject {
  
  var userid: String?
  var code: String?
  var created: String?
  var username: String?
  var phone: String?
  var sex: Int16?
  var user_applevel: Int16?
  
  override init() {
    super.init()

  }
  
  init(dic:[String: AnyObject]){
    userid = dic["userid"] as?String
    created = dic["created"] as?String
    username = dic["username"] as?String
    if let phoneNumber = dic["phone"] as? NSNumber {
      phone = phoneNumber.stringValue
    }
    code = dic["code"] as? String
    user_applevel = dic["user_applevel"] as?Int16
    sex = dic["sex"] as?Int16
  }
  
}
