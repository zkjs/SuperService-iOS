//
//  TeamModel.swift
//  SuperService
//
//  Created by admin on 15/10/21.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class TeamModel: NSObject {

  var username: String?
  
  var phone: String?
  var roleid: Int16?
  var realname: String?
  var email: String?
  var rolename: String?
  var sex:Int?
  var userimage: String?
  var roledesc: String?
  var userid: String?

  init(dic:JSON){
    if let name = dic["username"].string {
      self.username = name
    } else if let name = dic["username"].number {
      self.username = name.stringValue
    }
    phone = dic["phone"].string ?? ""
    realname = dic["realname"].string ?? ""
    sex = dic["sex"].int
    userimage = dic["userimage"].string ?? ""
    userid = dic["userid"].string ?? ""
    roledesc = dic["roledesc"].string ?? ""
    email = dic["email"].string ?? ""
    rolename = dic["rolename"].string ?? ""
    
   
  }

  override init() {
    super.init()
  }

}
