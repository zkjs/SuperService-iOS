//
//  BindCodeModel.swift
//  SuperService
//
//  Created by Hanton on 12/13/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class BindCodeModel: NSObject {

  var code: String?
  var userid: String?
  var username: String?
  var phone: String?
  var userimage: String?
  var userstatus: String?

  
  init(dic:JSON) {
    code = dic["code"].string
    userid = dic["userid"].string
    username = dic["username"].string
    phone = dic["phone"].string
    userimage = dic["userimage"].string
    userstatus = dic["userstatus"].string
  }
  
}
