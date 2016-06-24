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
  var svrname:String?
  var status:String?
  var statuscode:String?
  var isowner:Int?
  var userid:String?
  var username:String?
  var userimage:String?
  var operationseq:String?
  var createtime:String?
  
  override init() {
    super.init()
    
  }
  init(dic:JSON) {
    taskid = dic["task"].string ?? ""
    svrname = dic["svrname"].string ?? ""
    status = dic["status"].string ?? ""
    statuscode = dic["statuscode"].string ?? ""
    isowner = dic["isowner"].int ?? 0
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
    userimage = dic["userimage"].string ?? ""
    operationseq = dic["operationseq"].string ?? ""
    createtime = dic["createtime"].string ?? ""
  }

}
