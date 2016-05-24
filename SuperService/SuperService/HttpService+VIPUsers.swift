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
    let dic = ["page":page,"page_size":8]
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