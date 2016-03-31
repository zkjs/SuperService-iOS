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
  
  init(json:JSON) {
        salecode = json["salecode"].string
  }

}
