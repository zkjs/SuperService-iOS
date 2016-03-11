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
    case UpdateInfo
    
    
    var description: String {
      switch self {
      case .UserInfo:  return "/res/v1/query/user/all"
      case.UpdateInfo: return "/res/v1/update/user"
      }
    }
  }
  static let baseURLUpdate = "http://p.zkjinshi.com/test/for/"
  //获取登录用户的资料
  static func getUserInfo(completionHandler:HttpCompletionHandler){
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
  
  //////注册流程 完善资料
  static func updateUserInfo(isRegister: Bool, realname:String?,eamil:String?,sex:String?,image:UIImage?, completionHandler:HttpCompletionHandler) {
    if realname == nil && sex == nil && image == nil {
      return
    }
    let urlString = baseURLUpdate + ResourcePathAccount.UpdateInfo.description
    var parameters = [String:String]()
    if isRegister {
      if let eamil = eamil {
        parameters["eamil"] = eamil
      }
    } else {
      if let realname = realname {
        parameters["username"] = realname
      }
    }
    if let sex = sex {
      parameters["sex"] = sex
    }
    
    guard  let token = TokenPayload.sharedInstance.token else {return}
    var headers = ["Content-Type":"multipart/form-data"]
    headers["Token"] = token
    
    upload(.POST, urlString,headers: headers,multipartFormData: {
      multipartFormData in
      if let image = image, let imageData = UIImageJPEGRepresentation(image, 1.0) {
        multipartFormData.appendBodyPart(data: imageData, name: "image", fileName: "image", mimeType: "image/png")
      }
      for (key, value) in parameters {
        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
      }
      
      }, encodingCompletion: {
        encodingResult in
        switch encodingResult {
        case .Success(let upload, _, _):
          upload.response(completionHandler: { (request, response, data, error) -> Void in
            if let error = error {
              print(error)
            } else {
              print(self.jsonFromData(data))
              if let data = data {
                let json = JSON(data: data)
                if json["res"].int == 0 {
                  print(json["resDesc"].string)
                  if let userData = json["data"].dictionary  {
                    AccountInfoManager.sharedInstance.saveAccountInfo(userData)
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
                  if let key = json["res"].int {
                    ZKJSTool.showMsg("\(key)")
                  }
                }
              }
            }
          })
          
        case .Failure(let encodingError):
          print(encodingError)
        }
    })
    
  }
  
}