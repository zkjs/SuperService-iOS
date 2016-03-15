//
//  AreaModel.swift
//  SuperService
//
//  Created by AlexBang on 15/10/31.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class AreaModel: NSObject {
  var locid:String?
  var sensorid:String?
  var major:String?
  var minior:String?
  var uuid:String?
  var subscribed:Int?
  var locdesc:String?


  init(dic:JSON) {
    locid  = dic["locid"].string ?? ""
    sensorid = dic["sensorid"].string ?? ""
    major = dic["major"].string ?? ""
    minior = dic["minior"].string ?? ""
    uuid = dic["uuid"].string ?? ""
    subscribed = dic["subscribed"].int ?? 0
    locdesc = dic["locdesc"].string ?? ""
    
  }
}
