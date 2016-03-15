//
//  NoticeModel.swift
//  SuperService
//
//  Created by AlexBang on 15/11/16.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class NoticeModel: NSObject {
  var locid:String?
  var major:String?
  var minor:String?
  var uuid:String?
   var sensorid:String?
   var subscribed:Int?
  
  init(dic:JSON) {
    locid = dic["locid"].string ?? ""
    major = dic["major"].string ?? ""
    minor = dic["minor"].string ?? ""
    sensorid = dic["sensorid"].string ?? ""
    subscribed = dic["subscribed"].int ?? 0
  }

}
