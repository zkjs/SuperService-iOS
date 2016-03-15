//
//  HttpService+Contacts.swift
//  SuperService
//
//  Created by AlexBang on 16/3/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  
  private enum queryContactsSource: CustomStringConvertible {
    case MyClients                // 我的客人（ss），查询销售的客人资料
    case MyTeam                   // 根据shopid获取客服成员-按角色区分
    case AddMember                // 批量注册用户
 
    
    var description: String {
      switch self {
      case.MyClients:             return "/for/res/v1/query/sis/"
      case.MyTeam:                return "/for/res/v1/query/sss"
      case.AddMember:             return "/for/res/v1/register/users"
      
      }
    }
  }
  
   
  static func queryUserInfo(completionHandler:([AddClientModel]?,NSError?) -> ()) {
    let urlString =  queryContactsSource.MyClients.description.fullUrl
    get(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array {
          var users = [AddClientModel]()
          for userData in data {
            let user = AddClientModel(dic: userData)
            users.append(user)
          }
          print(users.count)
          completionHandler(users,nil)
        }
      }
    }
  }
  
  static func queryTeamsInfo(completionHandler:([TeamModel]?,NSError?) -> ()) {
    let urlString =  queryContactsSource.MyClients.description.fullUrl
    get(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array {
          var users = [TeamModel]()
          for userData in data {
            let user = TeamModel(dic: userData)
            users.append(user)
          }
          completionHandler(users,nil)
        }
      }
    }
  }
  
  static func AddMember(massDic:NSDictionary, completionHandler:(JSON?,NSError?) -> ()) {
    let urlString =  queryContactsSource.AddMember.description.fullUrl
    post(urlString, parameters: massDic as? [String : AnyObject]) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
       completionHandler(json,nil)
      }
    }
  }


}