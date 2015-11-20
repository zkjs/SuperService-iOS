//
//  NoticeModel.swift
//  SuperService
//
//  Created by AlexBang on 15/11/16.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class NoticeModel: NSObject {
  var empid:NSNumber?
  var id:NSNumber?
  var shopid:NSNumber?
  var locid:NSNumber?
  
  init(dic:[String:AnyObject]) {
    locid  = dic["locid"] as? NSNumber
    shopid = dic["shopid"] as? NSNumber
    empid = dic["empid"] as? NSNumber
    id = dic["id"] as? NSNumber
    
  }

}
