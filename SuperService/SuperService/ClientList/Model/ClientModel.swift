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
  var sex: Int?
  var user_applevel: Int?
  
  override init() {
    super.init()

  }
  
  init(dic:[String: AnyObject]){
    userid = dic["userid"] as? String
    created = dic["created"] as? String
    if let name = dic["username"] as? String {
      username = name
    } else if let name = dic["username"] as? NSNumber {
      username = name.stringValue
    }
    if let phoneNumber = dic["phone"] as? NSNumber {
      phone = phoneNumber.stringValue
    }
    code = dic["code"] as? String
    if let userLevel = dic["user_applevel"] as? NSNumber {
      user_applevel = userLevel.integerValue
    }
    if let clientSex = dic["sex"] as? NSNumber {
      sex = clientSex.integerValue
    }
  }
  
}
