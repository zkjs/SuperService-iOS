//
//  CodeModel.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class CodeModel: NSObject {
  var salesid:String?
  var codeid:NSNumber?
  var salecode:String?
  init(dic:[String:AnyObject]) {
    
    salesid = dic["salesid"] as? String
    codeid = dic["codeid"] as? NSNumber
    salecode = dic["salecode"] as? String
    
  }


}
