//
//  Client.swift
//  SuperService
//
//  Created by Hanton on 10/19/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

//"order_count" = 1;
//phone = 18925232944;
//sex = 0;
//"user_level" = 0;
//userid = 5603d8d417392;
//username = Hanton;

class ClientModel: NSObject {

  var ID = ""
  var name = ""
  var level: NSNumber = 0
  var sex: NSNumber = 0
  var phone: NSNumber = 0
  var orderCount: NSNumber = 0
  
  override init() {}
  
  init(dict: [String: AnyObject]) {
    if let ID = dict["userid"] as? String {
      self.ID = ID
    }
    if let name = dict["username"] as? String {
      self.name = name
    }
    if let orderCount = dict["order_count"] as? NSNumber {
      self.orderCount = orderCount
    }
    if let phone = dict["phone"] as? NSNumber {
      self.phone = phone
    }
    if let sex = dict["sex"] as? NSNumber {
      self.sex = sex
    }
    if let level = dict["user_level"] as? NSNumber {
      self.level = level
    }
  }
  
}
