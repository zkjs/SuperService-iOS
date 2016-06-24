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
  var statuscode:String?
  
  init(json:JSON) {
    username = json["username"].string ?? ""
    userimage = json["userimage"].string ?? ""
    actiondesc = json["actiondesc"].string ?? ""
    createtime = json["createtime"].string ?? ""
    statuscode = json["statuscode"].string ?? ""
  }
}
