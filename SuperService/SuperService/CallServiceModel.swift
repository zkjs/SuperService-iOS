//
//  CallServiceModel.swift
//  SuperService
//
//  Created by AlexBang on 16/6/23.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class CallServiceModel: NSObject {
  var taskid:String?
  var srvname:String?
  var status:String?
  var statuscode:StatusType
  var isowner:Int?
  var userid:String?
  var username:String?
  var userimage:String?
  var operationseq:Int?
  var createtime:String?


  init(dic:JSON) {
    taskid = dic["taskid"].string ?? ""
    srvname = dic["srvname"].string ?? ""
    status = dic["status"].string ?? ""
    if let a = dic["statuscode"].int,status = StatusType(rawValue:a) {
      statuscode = status
    } else {
      statuscode = .Unknown
    }
    isowner = dic["isowner"].int ?? 0
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
    userimage = dic["userimage"].string ?? ""
    operationseq = dic["operationseq"].int ?? 0
    createtime = dic["createtime"].string ?? ""
  }

}
