//
//  Httpservice+Token.swift
//  SuperService
//
//  Created by Qin Yejun on 3/11/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension HttpService {
  
  //// PAVO 认证服务API : Token管理 :
  static func refreshToken(completionHandler:HttpCompletionHandler?) {
    let urlString = baseCodeURL + ResourcePath.Token.description
    
    put(urlString, parameters: nil) { (json, error) -> Void in
      completionHandler?(json, error)
      if let json = json {
        guard let token = json["token"].string else {
          print("no token")
          return
        }
        print("refresh token success:\(token)")
        TokenPayload.sharedInstance.saveTokenPayload(token)
      }
    }
  }
  
  //// PAVO 认证服务API : Token管理 :
  static func deleteToken(completionHandler:HttpCompletionHandler) {
    let urlString = baseCodeURL + ResourcePath.Token.description
    guard   let token = TokenPayload.sharedInstance.token else {return}
    let dic = ["token":token]
    put(urlString, parameters: dic) { (json, error) -> Void in
      completionHandler(json, error)
    }
  }
  
}