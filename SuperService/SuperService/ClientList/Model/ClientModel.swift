//
//  ClientModel.swift
//  SuperService
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class ClientModel: NSObject {
  var userid: String?
  var shopid: String?
  var salesid: String?
  var user_level: Int16?
  var level_desc: String?
  var card_no: String?
  var is_special: String?
  var nationality: String?
  var like_desc: String?
  var taboo_desc: String?
  var other_desc: String?
  var created: String?
  var modified: String?
  var username: String?
  var phone: String?
  var company: String?
  var position: String?
  var Is_bill: Int16?
  
  override init() {
    super.init()
  }
  init(dic:[String: AnyObject]){
    userid = dic["userid"] as?String
    shopid = dic["shopid"] as?String
    salesid = dic["salesid"] as?String
    user_level = dic["user_level"] as?Int16
    level_desc = dic["level_desc"] as?String
    card_no = dic["card_no"] as?String
    is_special = dic["is_special"] as?String
    nationality = dic["nationality"] as?String
    like_desc = dic["like_desc"] as?String
    taboo_desc = dic["taboo_desc"] as?String
    other_desc = dic["other_desc"] as?String
    created = dic["created"] as?String
    modified = dic["modified"] as?String
    username = dic["username"] as?String
    if let phoneNumber = dic["phone"] {
      phone = phoneNumber.stringValue
    }
    company = dic["company"] as?String
    position = dic["position"] as?String
    Is_bill = dic["Is_bill"] as?Int16
  }
}
