//
//  TasktrackingModel.swift
//  SuperService
//
//  Created by AlexBang on 16/6/23.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class TasktrackingModel:NSObject {
  var taskid: String?
  var userid: String?
  var username: String?
  var userimage: String?
  var locdesc: String?
  var srvname: String?
  var createtime: String?
  var historyData:[TaskhistoryModel]?
  
  override init() {
    super.init()
    
  }
  
  init(dic:JSON) {
    taskid = dic["taskid"].string ?? ""
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
    userimage = dic["userimage"].string ?? ""
    locdesc = dic["locdesc"].string ?? ""
    srvname = dic["srvname"].string ?? ""
    createtime = dic["createtime"].string ?? ""
    if let  historys = dic["history"].array where historys.count > 0 {
      var ordersArray = [TaskhistoryModel]()
      for o in historys {
        let order = TaskhistoryModel(json: o)
        ordersArray.append(order)
      }
      historyData = ordersArray
    } else {
      historyData = nil
    }
  }
    
}
