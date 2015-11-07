//
//  CodeModel.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class CodeModel: NSObject {
  
  
  var salecode:String?
  var username:String?
  var created:String?
  var userid:String?
  init(dic:[String:AnyObject]) {
    
    salecode = dic["salecode"] as? String
    username = dic["username"] as? String
    userid = dic["userid"] as? String
    created = dic["created"] as? String
    
  }


}
