//
//  TokenPayload.swift
//  SuperService
//
//  Created by Qin Yejun on 3/1/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

class TokenPayload:NSObject {
  private static let kNSDefaults = "tokenPayload"
  static let sharedInstance = TokenPayload()
  private override init() {
    super.init()
    self.loadData()
  }
  
  private(set) var token:String?
  private(set) var tokenPayload:String?
  var userID:String? {
    return json?["sub"].string
  }
  var type:Int? {
    return json?["type"].int
  }
  var expire:Int? {
    return json?["expire"].int
  }
  var shopid:String? {
    return json?["shopid"].string
  }
  // 角色列表
  var roles:[String]? {
    return json?["roles"].array?.flatMap{$0.string}
  }
  // 权限列表
  var features:[String]? {
    return json?["features"].array?.flatMap{$0.string}
  }
  var complete:Bool {
    if let com  = json?["complete"] {
      return com != 0
    }
    return true
  }
  
  var isLogin:Bool {
    guard let userID = userID else { return false }
    return !userID.isEmpty
  }
  
  var isAdmin:Bool {
    return self.roles?.contains("ADMIN") ?? false
  }
  
  private var json: JSON? {
    guard let data = self.tokenPayload?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
      return nil
    }
    return JSON(data: data)
  }
  
  private func loadData() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    if let token = userDefaults.objectForKey(TokenPayload.kNSDefaults) as? String {
      parseToken(token)
    }
  }
  
  //// 解析token : JWT 格式
  private func parseToken(tokenFullString:String) {
    let arr = tokenFullString.characters.split { $0 == "." }.map(String.init)
    let payload = arr.count > 1 ? arr[1] : ""
    
    //兼容java base64解密，不足4X位补充'='
    let rem = payload.characters.count % 4
    var ending = ""
    if rem > 0 {
      let amount = 4 - rem
      ending = String(count: amount, repeatedValue: Character("="))
    }
    let base64 = payload.stringByReplacingOccurrencesOfString("-", withString: "+", options: NSStringCompareOptions(rawValue: 0), range: nil)
      .stringByReplacingOccurrencesOfString("_", withString: "/", options: NSStringCompareOptions(rawValue: 0), range: nil) + ending
    
    let decodedData = NSData(base64EncodedString:base64, options:NSDataBase64DecodingOptions(rawValue: 0))
    let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding) as! String
    
    self.tokenPayload = decodedString
    self.token = tokenFullString
  }
  
  //// 持久化保存token
  func saveTokenPayload(tokenFullString:String) {
    parseToken(tokenFullString)
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setObject(tokenFullString, forKey: TokenPayload.kNSDefaults)
    userDefaults.synchronize()
  }
  
  
  func clearCacheTokenPayload() {
    let userDefaults = NSUserDefaults()
    userDefaults.setObject(nil, forKey: TokenPayload.kNSDefaults)
    userDefaults.synchronize()
    token = nil
    tokenPayload = nil
  }
  
  // 是否有某些权限
  func hasPermission(p:Permission) -> Bool {
    return features?.contains(p.rawValue) ?? false
  }
  
}