//
//  TaskhistoryModel.swift
//  SuperService
//
//  Created by AlexBang on 16/6/23.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TaskhistoryModel {
  var username:String?
  var userimage:String?
  var actiondesc:String?
  var createtime:String?
  var statuscode:ActionType
  var actionname:String?
  var userid:String?
  
  init(json:JSON) {
    username = json["username"].string ?? ""
    userimage = json["userimage"].string ?? ""
    actiondesc = json["actiondesc"].string ?? ""
    createtime = json["createtime"].string ?? ""
    if let a = json["actioncode"].int,status = ActionType(rawValue:a) {
      statuscode = status
    } else {
      statuscode = .Unknown
    }
    actionname = json["actionname"].string ?? ""
    userid = json["userid"].string ?? ""
  }
}
