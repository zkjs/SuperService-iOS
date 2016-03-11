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
  
  init(dic:JSON){
    
    if let userID = dic["userid"].string  {
      userid = userID
    } else if let userID = dic["userid"].number {
      userid = userID.stringValue
    }
    created = dic["created"].string ?? ""
    
    if let name = dic["username"].string {
      username = name
    } else if let name = dic["username"].number {
      username = name.stringValue
    }
    if let phoneNumber = dic["phone"].number{
      phone = phoneNumber.stringValue
    }
    code = dic["code"].string ?? ""
    if let userLevel = dic["user_applevel"].number {
      user_applevel = userLevel.integerValue
    }

    if let clientSex = dic["sex"].number{
      sex = clientSex.integerValue
    }
  }
  
}
