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
  var email:String?
  var userstatus:Int?
  var userimage:String?
  var realname:String?
  
  override init() {
    super.init()
  }
  
  init(dic:JSON){
    
    if let userID = dic["userid"].string {
      userid = userID
    } else if let userID = dic["userid"].number {
      userid = userID.stringValue
    }
    created = dic["created"].string
    
    if let name = dic["username"].string {
      username = name
    } else if let name = dic["username"].number {
      username = name.stringValue
    }
    
    if let phoneNumber = dic["phone"].string{
      phone = phoneNumber
    } else if let phoneNumber = dic["phone"].number {
      phone = phoneNumber.stringValue
    }
      sex = dic["sex"].string ?? ""
      id = dic["id"].string ?? ""
    userstatus = dic["userstatus"].int
    email = dic["email"].string
    userimage = dic["userimage"].string ?? ""
    realname = dic["realname"].string ?? ""
    
      }

}
