//
//  AccountManager.swift
//  SuperService
//
//  Created by Hanton on 10/14/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

class AccountManager: NSObject {
  
//  {
//  "set": true,
//  "userid": "5577ecee5acc7",
//  "shopid": "120",
//  "fullname": "长沙芙蓉国温德姆至尊豪廷大酒店",
//  "token": "jxT3sB_U2M2EsGF_",
//  "name": "王二麻子",
//  "roleid": "4",
//  "locid": "1,2,3"
//  }

  private(set) var userid = ""
  private(set) var shopid = ""
  private(set) var fullname = ""
  private(set) var token = ""
  private(set) var name = ""
  private(set) var roleid = ""
  private(set) var locid = ""

  class func sharedInstance() -> AccountManager {
    struct Singleton {
      static let instance = AccountManager()
    }
    return Singleton.instance
  }
  
  override init() {
    let userDefaults = NSUserDefaults()
    userid = userDefaults.objectForKey("userid") as? String ?? ""
    shopid = userDefaults.objectForKey("shopid") as? String ?? ""
    fullname = userDefaults.objectForKey("fullname") as? String ?? ""
    token = userDefaults.objectForKey("token") as? String ?? ""
    name = userDefaults.objectForKey("name") as? String ?? ""
    roleid = userDefaults.objectForKey("roleid") as? String ?? ""
    locid = userDefaults.objectForKey("locid") as? String ?? ""
  }
  
  func saveAccountWithDict(dict: NSDictionary) {
    userid = dict["userid"] as! String
    shopid = dict["shopid"] as! String
    fullname = dict["fullname"] as! String
    token = dict["token"] as! String
    name = dict["name"] as! String
    roleid = dict["roleid"] as! String
    locid = dict["locid"] as! String
    
    let userDefaults = NSUserDefaults()
    userDefaults.setObject(dict["userid"], forKey: "userid")
    userDefaults.setObject(dict["shopid"], forKey: "shopid")
    userDefaults.setObject(dict["fullname"], forKey: "fullname")
    userDefaults.setObject(dict["token"], forKey: "token")
    userDefaults.setObject(dict["name"], forKey: "name")
    userDefaults.setObject(dict["roleid"], forKey: "roleid")
    userDefaults.setObject(dict["locid"], forKey: "locid")
    userDefaults.synchronize()
  }
  
}
