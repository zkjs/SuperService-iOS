//
//  MemberpersonModel.swift
//  SuperService
//
//  Created by AlexBang on 16/7/1.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class MemberpersonModel: NSObject {
  let userid:String
  let username:String
  let userimage:String
  var selected:Bool = true
  
  
  
  init(dic:JSON) {
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
    userimage = dic["userimage"].string ?? ""
  }

}
