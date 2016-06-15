//
//  HttpService+VIPUsers.swift
//  SuperService
//
//  Created by AlexBang on 16/5/24.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  func whiteUsersList(page:Int,completionHandler:([AddClientModel]?,NSError?) -> ()) {
    let urlString = ResourcePath.VIPUsers.description.fullUrl
    let dic = ["page":page,"page_size":20]
    get(urlString, parameters: dic) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array {
          var users = [AddClientModel]()
          for userData in data {
            let user = AddClientModel(dic: userData)
            users.append(user)
          }
          completionHandler(users,nil)
        }
      }
    }
  }
  //删除白名单会员
  func deleteWhiteUser(userid:String,phone:String,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = ResourcePath.DeleteVIPUser.description.fullUrl
    let dic = ["userid":userid,"phone":phone]
    delete(urlString, parameters: dic) { (json, error) -> Void in
      if let error = error {
        completionHandler(json,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  //删除团队成员
  func deleteTeamUser(userid:String,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = ResourcePath.DeleteTeamUser.description.fullUrl + "\(userid)"
    delete(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(json,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  func AddWhiteUser(massDic:NSDictionary, completionHandler:(JSON?,NSError?) -> ()) {
    let urlString =  ResourcePath.AddWhiteUser.description.fullUrl
    post(urlString, parameters: massDic as? [String : AnyObject]) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
}