//
//  MemberModel.swift
//  SuperService
//
//  Created by admin on 15/10/28.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class MemberModel: NSObject {
  var dept_code: String?
  var dept_name: String?
  var deptid: String?
  var shopid: String?
  
  init(dic:[String: AnyObject]){
    dept_code = dic["dept_code"] as?String
    dept_name = dic["dept_name"] as?String
    if let deptid = dic["deptid"] as? NSNumber {
      self.deptid = deptid.stringValue
    }
    shopid = dic["shopid"] as?String
  }
  
  override init() {
    super.init()
  }

}
