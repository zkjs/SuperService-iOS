//
//  TeamModel.swift
//  SuperService
//
//  Created by admin on 15/10/21.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class TeamModel: NSObject {

  var name: String?
  var phone: NSNumber?
  var roleid: Int16?
  var dept_name: String?
  var salesid: String?

  init(dic:[String: AnyObject]){
    name = dic["name"] as? String
    phone = dic["phone"] as? NSNumber
    dept_name = dic["dept_name"] as? String
    roleid = dic["roleid"] as? Int16
    salesid = dic["salesid"] as? String
  }

  override init() {
    super.init()
  }

}
