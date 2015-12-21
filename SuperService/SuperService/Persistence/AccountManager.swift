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
  private(set) var phone = ""
  private(set) var avatarImageData = NSData()
  private(set) var avatarImage = UIImage(named: "ic_home_nor")

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
    phone = userDefaults.objectForKey("phone") as? String ?? ""
    if userDefaults.objectForKey("avatarImageData") != nil {
      if let imageData = userDefaults.objectForKey("avatarImageData") as? NSData {
        avatarImageData = imageData
        if let image = UIImage(data: avatarImageData) {
          avatarImage = image
        }
      }
    }
    
  }
  
  func saveAccountWithDict(dict: [String: AnyObject]) {
    
    if let userID = dict["userid"] as? String {
      self.userID = userID
    } else if let salesID = dict["salesid"] as? String {
      self.userID = salesID
    }
    
    let urlString = kBaseURL + "uploads/users/\(userID).jpg"
    if let url = NSURL(string: urlString) {
      print(url)
        if let data = NSData(contentsOfURL: url) {
          self.avatarImageData = data
          if let image = UIImage(data: self.avatarImageData) {
            self.avatarImage = image
        }
      }
    }
    
    if let shopID = dict["shopid"] as? NSNumber {
      self.shopID = shopID.stringValue
    } else if let shopID = dict["shopid"] as? String {
      self.shopID = shopID
    }
    
    if let phone = dict["phone"] as? NSNumber {
      self.phone = phone.stringValue
    } else if let phone = dict["phone"] as? String {
      self.phone = phone
    }
    
    shopName = dict["fullname"] as! String
    token = dict["token"] as! String
    if let userName = dict["name"] as? String {
       self.userName = userName
    }
   
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
    
    userDefaults.setObject(shopID, forKey: "shopid")
    userDefaults.setObject(shopName, forKey: "fullname")
    userDefaults.setObject(token, forKey: "token")
    userDefaults.setObject(userName, forKey: "name")
    userDefaults.setObject(roleID, forKey: "roleid")
    userDefaults.setObject(beaconLocationIDs, forKey: "locid")
    userDefaults.setObject(url, forKey: "url")
    userDefaults.setObject(avatarImageData, forKey: "avatarImageData")
    userDefaults.setObject(phone, forKey: "phone")
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
    userDefaults.setObject(nil, forKey: "phone")
    //userDefaults.setObject(nil, forKey: "avatarImageData")
    
    userDefaults.synchronize()
  }
  
  func clearAvatarImageCache() {
     let userDefaults = NSUserDefaults()
    userDefaults.setObject(nil, forKey: "avatarImageData")
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
  
  func saveUserName(userName: String) {
    self.userName = userName
    let userDefaults = NSUserDefaults()
    userDefaults.setObject(userName, forKey: "name")
  }
  
  func saveAvatarImageData(imageData: NSData) {
    avatarImageData = imageData
    let userDefaults = NSUserDefaults()
    userDefaults.setObject(nil, forKey: "avatarImageData")
    userDefaults.setObject(avatarImageData, forKey: "avatarImageData")
    
    if let image = UIImage(data: avatarImageData) {
      self.avatarImage = image
    }
  }
  
  func isAdmin() -> Bool {
    return roleID == "1" ? true : false
  }
  
}
