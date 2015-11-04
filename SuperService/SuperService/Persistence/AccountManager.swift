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

  private(set) var userID = ""
  private(set) var shopID = ""
  private(set) var shopName = ""
  private(set) var token = ""
  private(set) var userName = ""
  private(set) var roleID = ""
  private(set) var beaconLocationIDs = ""
  private(set) var deviceToken = ""
  private(set) var url = ""

  class func sharedInstance() -> AccountManager {
    struct Singleton {
      static let instance = AccountManager()
    }
    return Singleton.instance
  }
  
  override init() {
    let userDefaults = NSUserDefaults()
    userID = userDefaults.objectForKey("userid") as? String ?? ""
    shopID = userDefaults.objectForKey("shopid") as? String ?? ""
    shopName = userDefaults.objectForKey("fullname") as? String ?? ""
    token = userDefaults.objectForKey("token") as? String ?? ""
    userName = userDefaults.objectForKey("name") as? String ?? ""
    roleID = userDefaults.objectForKey("roleid") as? String ?? ""
    beaconLocationIDs = userDefaults.objectForKey("locid") as? String ?? ""
    url = userDefaults.objectForKey("url") as? String ?? ""
  }
  
  
  
  func saveAccountWithDict(dict: [String: AnyObject]) {
    if let userID = dict["userid"] as? String {
      self.userID = userID
    } else if let salesID = dict["salesid"] as? String {
      self.userID = salesID
    }
    
    if let shopID = dict["shopid"] as? NSNumber {
      self.shopID = shopID.stringValue
    } else if let shopID = dict["shopid"] as? String {
      self.shopID = shopID
    }
    
    
    
    shopName = dict["fullname"] as! String
    token = dict["token"] as! String
    userName = dict["name"] as! String
    if let roleID = dict["roleid"] as? String {
      self.roleID = roleID
    } else if let roleID = dict["roleID"] as? String {
      self.roleID = roleID
    }
    
    beaconLocationIDs = dict["locid"] as? String ?? ""
    url = dict["url"] as? String ?? ""
    
    let userDefaults = NSUserDefaults()
    if let userID = dict["userid"] as? String {
      userDefaults.setObject(userID, forKey: "userid")
    } else if let salesID = dict["salesid"] as? String {
      userDefaults.setObject(salesID, forKey: "userid")
    }
    
    userDefaults.setObject(dict["shopid"], forKey: "shopid")
    userDefaults.setObject(dict["fullname"], forKey: "fullname")
    userDefaults.setObject(dict["token"], forKey: "token")
    userDefaults.setObject(dict["name"], forKey: "name")
    userDefaults.setObject(dict["roleid"], forKey: "roleid")
    userDefaults.setObject(dict["locid"], forKey: "locid")
    userDefaults.setObject(dict["url"], forKey: "url")
    userDefaults.synchronize()
  }
  
  func clearAccountCache() {
    let userDefaults = NSUserDefaults()
    userDefaults.setObject(nil, forKey: "userid")
    userDefaults.setObject(nil, forKey: "shopid")
    userDefaults.setObject(nil, forKey: "fullname")
    userDefaults.setObject(nil, forKey: "token")
    userDefaults.setObject(nil, forKey: "name")
    userDefaults.setObject(nil, forKey: "roleid")
    userDefaults.setObject(nil, forKey: "locid")
    userDefaults.setObject(nil, forKey: "url")
    userDefaults.synchronize()
  }
  
  func saveDeviceToken(deviceToken: String) {
    self.deviceToken = deviceToken
  }
  func savebeaconLocationIDs(beaconLocationIDs: String) {
    self.beaconLocationIDs = beaconLocationIDs
    let userDefaults = NSUserDefaults()
    userDefaults.setObject(beaconLocationIDs, forKey: "locid")
  }
}
