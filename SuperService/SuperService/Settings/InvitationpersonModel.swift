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
  var member:[MemberpersonModel]!
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
      member = []
    }
  }
  
  func selectedMembers() -> [MemberpersonModel] {
    return member.filter{ $0.selected }
  }
  
  func isAllSelected() -> Bool {
    return member.filter{ !$0.selected }.count == 0 
  }
  
  func selectMembers(userids:[String]) {
    for (k,m) in member.enumerate() {
      member[k].selected = userids.contains(m.userid)
    }
  }
  
  func selectAll() {
    for (k,m) in member.enumerate() {
      member[k].selected = true
    }
  }
  
  func unselectAll() {
    for (k,m) in member.enumerate() {
      member[k].selected = false
    }
  }

}
//struct MemberpersonModel {
//  var userid:String?
//  var username:String?
//  var userimage:String?
//  
//  
//  
//  init(dic:JSON) {
//    userid = dic["userid"].string ?? ""
//    username = dic["username"].string ?? ""
//    userimage = dic["userimage"].string ?? ""
//  }
//  
//}
