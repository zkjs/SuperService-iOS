//
//  HttpService+Contacts.swift
//  SuperService
//
//  Created by AlexBang on 16/3/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  
  static let baseURLContacts = "http://p.zkjinshi.com/test/for/"
  private enum queryContactsSource: CustomStringConvertible {
    case MyClients
    case MyTeam
    case AddMember
 
    
    var description: String {
      switch self {
      case.MyClients: return "/res/v1/query/sis/"
      case.MyTeam: return " /res/v1/query/sss"
      case.AddMember: return "/res/v1/register/users"
      
      }
    }
  }
  
   
  static func queryUserInfo(completionHandler:([AddClientModel]?,NSError?) -> ()) {
    let urlString = baseURLContacts + queryContactsSource.MyClients.description
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
    let urlString = baseURLContacts + queryContactsSource.MyClients.description
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
          print(users.count)
          completionHandler(users,nil)
        }
      }
    }
  }
  
  static func AddMember(massArray:NSArray, completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = baseURLContacts + queryContactsSource.AddMember.description
    post(urlString, parameters: nil) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
       completionHandler(json,nil)
      }
    }
  }


}