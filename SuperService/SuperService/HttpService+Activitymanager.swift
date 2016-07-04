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
  
  func createActivity(actid:String = "", actname:String,actcontent:String,startdate:String,enddate:String,
                      acturl:String, invitesi:String, portable:Bool = true,
                      maxtake:Int = 0, image:UIImage?, completionHandler:HttpCompletionHandler) {
    guard  let token = TokenPayload.sharedInstance.token else {return}
    var urlString = ResourcePath.CreatActivity.description.fullUrl
    if !actid.isEmpty {
      urlString = ResourcePath.EditActivity(actid: actid).description.fullUrl
    }
    
    var parameters = [String:String]()
    parameters["actname"] = actname
    parameters["actcontent"] = actcontent
    parameters["startdate"] = startdate
    parameters["enddate"] = enddate
    //parameters["actimage"] = nil
    parameters["maxtake"] = "\(maxtake)"
    parameters["acturl"] = acturl
    parameters["portable"] = portable ? "1" : "0"
    parameters["invitesi"] = invitesi
    
    var headers = ["Content-Type":"multipart/form-data"]
    headers["Token"] = token
    print(urlString)
    print(parameters)
    
    upload(.POST, urlString,headers: headers,multipartFormData: {
      multipartFormData in
      if let image = image, let imageData = UIImageJPEGRepresentation(image, 1.0) {
        multipartFormData.appendBodyPart(data: imageData, name: "actimage", fileName: "actimage", mimeType: "image/png")
      }
      for (key, value) in parameters {
        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
      }
      
    }, encodingCompletion: {
        encodingResult in
        switch encodingResult {
        case .Success(let upload, _, _):
          upload.response(completionHandler: { (request, response, data, error) -> Void in
            print("statusCode:\(response?.statusCode)")
            guard let statusCode = response?.statusCode else{
              let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
                code: 0,
                userInfo: ["res":"0","resDesc":"未知网络错误:)"])
              completionHandler(nil,e)
              return
            }
            if statusCode == 401 {//token过期
              print("invalid token:\(request)")
              TokenPayload.sharedInstance.clearCacheTokenPayload()
              NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGOUTCHANGE, object: nil)
              return
            } else if statusCode != 200 {
              let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
                code: statusCode,
                userInfo: ["res":"\(statusCode)","resDesc":"网络错误:\(statusCode)"])
              completionHandler(nil,e)
              return
            }
            
            if let error = error {
              print("api request fail [res code:,\(response?.statusCode)]:\(error)")
              completionHandler(nil,error)
            } else {
              print(self.jsonFromData(data))
              if let data = data {
                let json = JSON(data: data)
                if json["res"].int == 0 {
                  print(json["resDesc"].string)
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
            userInfo: ["res":"0","resDesc":"上传活动数据失败:)"])
          completionHandler(nil,e)
          print(encodingError)
        }
    })
    
  }
}
  