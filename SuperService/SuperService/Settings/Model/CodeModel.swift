//
//  CodeModel.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class CodeModel: NSObject {

  var salecode: String?
  var is_validity: NSNumber?
  
  init(dic:[String:AnyObject]) {
    salecode = dic["salecode"] as? String
    is_validity = dic["is_validity"] as? NSNumber
  }

}
