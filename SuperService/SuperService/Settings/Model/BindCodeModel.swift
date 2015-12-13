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
  var phone: NSNumber?
  
  init(dic: [String:AnyObject]) {
    code = dic["code"] as? String
    userid = dic["userid"] as? String
    username = dic["username"] as? String
    phone = dic["phone"] as? NSNumber
  }
  
}
