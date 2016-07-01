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
    var url = ""
    if actid.isEmpty == true {
       url = ResourcePath.ActivityList.description.fullUrl
    } else {
       url = ResourcePath.ActivityList.description.fullUrl + "actid=\(actid)"
    }
    
    get(url, parameters: nil) { (json, error) in
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
  
  func activitymemberlist(actid:String,completionHandler:([InvitationpersonModel]?,NSError?) -> ())  {
    let urlString = ResourcePath.Activitymember.description.fullUrl
    let dic = ["actid":actid]
    get(urlString, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array {
          var member = [InvitationpersonModel]()
          for userData in data {
            let user = InvitationpersonModel(dic: userData)
            member.append(user)
          }
          print(member.count)
          completionHandler(member,nil)
        } else {
          completionHandler([],nil)
        }        
      }
    }
  }
  
  func editactivity(actid:String,dic:[String:AnyObject], completionHandler:HttpCompletionHandler) {
    let urlString = ResourcePath.EditActivity.description.fullUrl + "/\(actid)"
    guard  let token = TokenPayload.sharedInstance.token else {return}
    let req = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    req.HTTPMethod = "POST"
    req.setValue("application/form", forHTTPHeaderField: "Content-Type")
    req.setValue(token, forHTTPHeaderField: "Token")
    
    do {
      req.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dic, options: [])
      request(req).response { (req, res, data, error) in
        print("statusCode:\(res?.statusCode) for url:\(req?.URL?.absoluteString)")
        
        if let error = error {
          completionHandler(nil,error)
        } else {
          print(self.jsonFromData(data))
          if let data = data {
            let json = JSON(data: data)
            if json["res"].int == 0 {
              completionHandler(json,nil)
              print(json["resDesc"].string)
            } else {
              print("error with reason: \(json["resDesc"].string)")
            }
          }
        }
      }
    } catch _ {
      
    }
  }
  
  func cancleActivity(actid:String,completionHandler:(JSON?,NSError?) -> ()) {
    let url = ResourcePath.CancleActivity.description.fullUrl + "/\(actid)"
    delete(url, parameters: nil) { (json, error) in
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
  