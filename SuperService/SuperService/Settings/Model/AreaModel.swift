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


  init(dic:JSON) {
    locid  = dic["locid"].string ?? ""
    area = dic["area"].string ?? ""
    payment_support = dic["payment_support"].int ?? 0
        
  }
}
