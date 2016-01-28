//
//  AddClientModel.swift
//  SuperService
//
//  Created by AlexBang on 16/1/28.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class AddClientModel: NSObject {
  var userid: String?
  var id: String?
  var created: String?
  var username: String?
  var phone: String?
  var sex: String?
  
  override init() {
    super.init()
  }
  
  init(dic:[String: AnyObject]){
    
    if let userID = dic["userid"] as? String {
      userid = userID
    } else if let userID = dic["userid"] as? NSNumber {
      userid = userID.stringValue
    }
    created = dic["created"] as? String
    
    if let name = dic["username"] as? String {
      username = name
    } else if let name = dic["username"] as? NSNumber {
      username = name.stringValue
    }
    if let phoneNumber = dic["phone"] as? NSNumber {
      phone = phoneNumber.stringValue
    }
    
      sex = dic["sex"] as? String
      id = dic["id"] as? String
    
    
      }

}
