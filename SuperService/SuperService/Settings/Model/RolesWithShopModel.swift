//
//  RolesWithShopModel.swift
//  SuperService
//
//  Created by AlexBang on 16/6/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class RolesWithShopModel: NSObject {
  var roleid:Int?
  var rolename:String?
  
  init(dic:JSON) {
    roleid = dic["roleid"].int ?? 0
    rolename = dic["rolename"].string ?? ""
  }

}
