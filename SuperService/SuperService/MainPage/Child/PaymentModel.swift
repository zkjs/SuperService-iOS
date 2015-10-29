//
//  PaymentModel.swift
//  SuperService
//
//  Created by Hanton on 10/29/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class PaymentModel: NSObject {

  var pay_id: NSNumber?
  var pay_code: String?
  var pay_name: String?
  var is_online: NSNumber?
  
  override var description: String {
    var output = "pay_id: \(pay_id)\n"
    output += "pay_code: \(pay_code)\n"
    output += "pay_name: \(pay_name)\n"
    output += "is_online: \(is_online)\n"
    return output
  }
  
  init(dic: [String:AnyObject]) {
    pay_id = dic["pay_id"] as? NSNumber
    pay_code = dic["pay_code"] as? String
    pay_name = dic["pay_name"] as? String
    is_online = dic["is_online"] as? NSNumber
  }
  
}
