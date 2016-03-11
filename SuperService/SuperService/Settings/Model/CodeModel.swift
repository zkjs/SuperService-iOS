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
  
  init(dic:JSON) {
    if let json = dic["data"].dictionary {
      if let  saleCode = json["saleCode"]!.int  {
        salecode = String(saleCode)
      } else {
        salecode = json["saleCode"]!.string
      }
    }
    
  }

}
