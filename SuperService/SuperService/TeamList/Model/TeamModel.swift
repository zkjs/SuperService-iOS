//
//  TeamModel.swift
//  SuperService
//
//  Created by admin on 15/10/21.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class TeamModel: NSObject {
  var name:String?
  var phone:String?
  var roleid:Int16?
  var role_name:String?
  var salesid:String?
  init(dic:[String: AnyObject]){
    name = dic["name"] as?String
    phone = dic["phone"] as?String
    role_name = dic["role_name"] as?String
    roleid = dic["roleid"] as?Int16
    salesid = dic["salesid"] as?String
    
  
  }
}
