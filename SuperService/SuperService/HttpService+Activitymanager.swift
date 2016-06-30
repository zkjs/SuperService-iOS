//
//  HttpService+Activitymanager.swift
//  SuperService
//
//  Created by AlexBang on 16/6/29.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  func activityManagerlist(actid:String,completionHandler:([ActivitymanagerModel]?,NSError?) -> ()) {
    let url = ResourcePath.ActivityList.description.fullUrl
    let dic = ["actid":actid]
    get(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array {
          var activity = [ActivitymanagerModel]()
          for userData in data {
            let user = ActivitymanagerModel(dic: userData)
            activity.append(user)
          }
          print(activity.count)
          completionHandler(activity,nil)
        } else {
          completionHandler([],nil)
        }
      }
    }
  }
  
  func creatActivity(dic:NSDictionary,completionHandler:(JSON?,NSError?) -> ()) {
    let url = ResourcePath.CreatActivity.description.fullUrl
    post(url, parameters: dic as? [String : AnyObject]) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"] {
          completionHandler(data,nil)
        }
      }
    }

  }
  
  func activitymemberlist(actid:String,completionHandler:(JSON?,NSError?) -> ())  {
    let urlString = ResourcePath.Activitymember.description.fullUrl
    let dic = ["actid":actid]
    get(urlString, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json {
          completionHandler(data,nil)
        }
        
      }
    }
  }
}
  