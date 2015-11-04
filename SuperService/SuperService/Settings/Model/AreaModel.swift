//
//  AreaModel.swift
//  SuperService
//
//  Created by AlexBang on 15/10/31.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class AreaModel: NSObject {
  var locid:NSNumber?
  var shopid:Int?
  var sensorid:Int?
  var major:Int?
  var status:Int?
  var minior:Int?
  var uuid:String?
  var locdesc:String?
  var remark:String?
  init(dic:[String:AnyObject]) {
    locid  = dic["locid"] as? NSNumber
    shopid = dic["shopid"] as? Int
    sensorid = dic["sensorid"] as? Int
    major = dic["major"] as? Int
    status = dic["status"] as? Int
    minior = dic["minior"] as? Int
    uuid = dic["uuid"] as? String
    locdesc = dic["locdesc"] as? String
    remark = dic["remark"] as? String
    
  }
}
