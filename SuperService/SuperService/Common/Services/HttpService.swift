//
//  HttpService.swift
//  SuperService
//  API数据 HTTP请求 service
//  Created by Qin Yejun on 3/1/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

typealias HttpCompletionHandler = (JSON?, NSError?) -> Void

struct HttpService {
  static let DefaultPageSize = 15
  
  enum ResourcePath: CustomStringConvertible {
    case ApiURL(path:String)
    case LoginPhone                             //// PAVO 认证服务API : 使用手机号&验证码登录
    case LoginUserName                          //// PAVO 认证服务API : 使用用户名和密码登录
    case Token                                  //// PAVO 认证服务API : Token管理 :
    case DeleteToken                            //// PAVO 认证服务API : 删除Token :
    case Code                                   //// PAVO 认证服务API : 验证码 : HEADER不需要Token
    case QueryUserInfo
    case CheckVersion(version:String)      // 检查App版本
    
    var description: String {
      switch self {
      case .ApiURL(let path):                   return "/api/\(path)"
      case .LoginPhone:                         return "/pav/sso/token/v1/phone/ss"
      case .LoginUserName:                      return "/pav/sso/token/v1/name/ss"
      case .Token:                              return "/pav/sso/token/v1"
      case .DeleteToken:                        return "/pav/sso/token/v1"
      case .Code :                              return "/pav/sso/vcode/v1/ss?source=login"
      case .QueryUserInfo:                      return "/res/v1/query/si/all"
      case .CheckVersion(let version):  return "/for/res/v1/systempub/upgrade/newestversion/1/IOS/\(version)"
      }
    }
  }
  
  static func jsonFromData(jsonData:NSData?) -> NSDictionary?  {
    guard let jsonData = jsonData else {
      return nil
    }
    guard let parsed = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary else {
      return nil
    }
    return parsed
  }
  
  static func put(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.PUT, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  static func post(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.POST, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  
  static func get(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.GET, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  
//  static let TokenForTest = "eyJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJiXzE5MjU0MWI3OWU3OWE0OWUiLCJ0eXBlIjoyLCJleHBpcmUiOjE0NTc1OTIyNzc3NDMsInJvbGVzIjpbXSwiZmVhdHVyZXMiOltdLCJzaG9waWQiOiI4ODg4In0.i-B1RcKkas8NAH-F8DiDVz925VKEtB_iELACKbWmt1jW6h3HTE9gXZx47kyjsuFwQGWW7NNcFLO87CUL16EqmKXLlLSjDxm92CQ5SIL3d4FwFrYwy5kYB6U_IIE-qeXAAT1x1V2aHfwOtdOxPMA6-xowpVZo1R_vtQ679FaV5tU"
  
  //HTTP REQUEST
  static func requestAPI(method: Method, urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    
    var headers = ["Content-Type":"application/json"]
    if let token = TokenPayload.sharedInstance.token {
      print("request with token:\(token)")
      headers["Token"] = token//.isEmpty ? TokenForTest : token
    } else {
      if tokenRequired {
        print("Token is required")
        return
      }
    }
    
    print(urlString)
    print(parameters)
    
    request(method, urlString, parameters: parameters, encoding: method == .GET ? .URLEncodedInURL : .JSON, headers: headers).response { (req, res, data, error) -> Void in
      if let error = error {
        print("api request fail:\(error)")
        completionHandler(nil,error)
      } else {
        print(jsonFromData(data))
        
        if let data = data {
          let json = JSON(data: data)
          if json["res"].int == 0 {
            completionHandler(json,nil)
            print(json["resDesc"].string)
          } else {
            var resDesc = ""
            if let key = json["res"].int {
              resDesc = ZKJSErrorMessages.sharedInstance.errorString("\(key)") ?? "错误码:\(key)"
            }
            let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
              code: json["res"].int ?? -1,
              userInfo: ["res":"\(json["res"].int)","resDesc":resDesc])
            completionHandler(json,e)
            print("api request error with reason: \(json["res"].int):\(json["resDesc"].string)")
            if let key = json["res"].int,
              let msg = ZKJSErrorMessages.sharedInstance.errorString("\(key)") {
                ZKJSTool.showMsg(msg)
            }
          }
        } else {
          let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
            code: -2,
            userInfo: ["res":"-2","resDesc": "服务器未返回数据"])
          completionHandler(nil,e)
          print("api request error with reason: \(e)")
        }
      }
    }
  }
  
  static func demo(param1:String, param2:String, completionHandler:(JSON?,NSError?) -> ()){
    let urlString = ResourcePath.ApiURL(path: "test").description.fullUrl
    
    let parameters = ["param1":param1,"param2":param2]
    
    requestAPI(.POST, urlString: urlString, parameters: parameters) { (json, err) -> Void in
      completionHandler(json,err)
    }
  }

}