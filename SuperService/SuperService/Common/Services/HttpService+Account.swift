//
//  HttpService+Account.swift
//  SuperService
//
//  Created by Qin Yejun on 3/11/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension HttpService {
  private enum ResourcePathAccount: CustomStringConvertible {
    case UserInfo
    
    var description: String {
      switch self {
      case .UserInfo:  return "/res/v1/query/user/all"
      }
    }
  }
  
  static func getUserinfo(completionHandler:HttpCompletionHandler){
    let urlString = baseRegisterURL + ResourcePathAccount.UserInfo.description
    get(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        print(error)
        completionHandler(json,error)
      } else {
        if let userData = json?["data"].array?.first?.dictionary  {
          AccountInfoManager.sharedInstance.saveAccountInfo(userData)
          completionHandler(json,nil)
        } else {
          completionHandler(json,error)
        }
      }
    }
  }
  
}