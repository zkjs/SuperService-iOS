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
  var area:String?
  var payment_support:Int?
  var beacons = [String:String]()
 
  init(dic:JSON) {
    locid  = dic["locid"].string ?? ""
    area = dic["area"].string ?? ""
    payment_support = dic["payment_support"].int ?? 0
    if let beaconsArr = dic["beacons"].array {
      for b in beaconsArr {
        let major = b["major"].string ?? ""
        var minor = b["minor"].string ?? "0"
        if minor.isEmpty {
          minor = "0"
        }
        let uuid = b["uuid"].string ?? ""
        let beaconString = "\(uuid)-\(major)-\(minor)"
        beacons[beaconString.uppercaseString] = locid
      }
    }
  }
}
