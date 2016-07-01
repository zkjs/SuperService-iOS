//
//  InvitationpersonModel.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

struct InvitationpersonModel {
  var roleid:String?
  var rolename:String?
  var member:[MemberpersonModel]?
  init(dic:JSON) {
    roleid = dic["roleid"].string ?? ""
    rolename = dic["rolename"].string ?? ""
    if let  persons = dic["member"].array {
      var ordersArray = [MemberpersonModel]()
      for o in persons {
        let person = MemberpersonModel(dic: o)
        ordersArray.append(person)
      }
      member = ordersArray
    } else {
      member = nil
    }
  }

}
struct MemberpersonModel {
  var userid:String?
  var username:String?
  
  init(dic:JSON) {
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
  }
  
}
