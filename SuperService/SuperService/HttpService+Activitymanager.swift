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
  
  func editactivity(actid:Int,actname:String?,actcontent:String?,startdate:String?,enddate:String?,actimage:String?,maxtake:Int,acturl:String?,portable:Int,invitesi:String?, completionHandler:HttpCompletionHandler) {
    let urlString = ResourcePath.EditActivity.description.fullUrl
    guard  let token = TokenPayload.sharedInstance.token else {return}
    var headers = ["Content-Type":"multipart/form-data"]
    headers["Token"] = token
    var parameters = [String:AnyObject]()
    if let actname = actname,let actcontent = actcontent,let startdate = startdate,let enddate = enddate,let actimage = actimage,let maxtake:Int = maxtake,let acturl = acturl,let portable:Int = portable,let invitesi = invitesi {
      parameters["actname"] = actname
      parameters["actcontent"] = actcontent
      parameters["startdate"] = startdate
      parameters["enddate"] = enddate
      parameters["actimage"] = actimage
      parameters["maxtake"] = maxtake
      parameters["acturl"] = acturl
      parameters["portable"] = portable
      parameters["invitesi"] = invitesi
    }
      
    upload(.POST, urlString,headers: headers,multipartFormData: {
      multipartFormData in
      for (key, value) in parameters {
        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
      }
      
      }, encodingCompletion: {
        encodingResult in
        switch encodingResult {
        case .Success(let upload, _, _):
          upload.response(completionHandler: { (request, response, data, error) -> Void in
            print("statusCode:\(response?.statusCode)")
            if let error = error {
              print("api request fail [res code:,\(response?.statusCode)]:\(error)")
              completionHandler(nil,error)
            } else {
              print(self.jsonFromData(data))
              if let data = data {
                let json = JSON(data: data)
                if json["res"].int == 0 {
                  print(json["resDesc"].string)
                  if let imgUrl = json["data"]["userimage"].string  where !imgUrl.isEmpty {
                    AccountInfoManager.sharedInstance.saveImageUrl(imgUrl)
                    completionHandler(json,nil)
                  } else {
                    completionHandler(json,error)
                  }
                  
                  completionHandler(json,nil)
                  
                } else {
                  let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
                    code: -1,
                    userInfo: ["res":"\(json["res"].int)","resDesc":json["resDesc"].string ?? ""])
                  completionHandler(json,e)
                  print("error with reason: \(json["resDesc"].string)")
                }
              }
            }
          })
          
        case .Failure(let encodingError):
          let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
            code: 0,
            userInfo: ["res":"0","resDesc":"上传数据失败:)"])
          completionHandler(nil,e)
          print(encodingError)
        }
    }) 
    }
}
  