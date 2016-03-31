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


  init(dic:JSON) {
    locid  = dic["locid"].string ?? ""
    area = dic["area"].string ?? ""
        
  }
}
