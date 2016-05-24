//
//  HttpService.swift
//  SuperService
//  API数据 HTTP请求 service
//  Created by Qin Yejun on 3/1/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

typealias HttpCompletionHandler = (JSON?, NSError?) -> Void

class HttpService {
  static let DefaultPageSize = 15
  
  static let sharedInstance = HttpService()
  private init() {}
  
  var refreshTokenTime: NSTimeInterval = NSDate().timeIntervalSince1970
  
  enum ResourcePath: CustomStringConvertible {
    case ApiURL(path:String)
    case LoginPhone                             //// PAVO 认证服务API : 使用手机号&验证码登录
    case LoginUserName                          //// PAVO 认证服务API : 使用用户名和密码登录
    case Token                                  //// PAVO 认证服务API : Token管理 :
    case DeleteToken                            //// PAVO 认证服务API : 删除Token :
    case Code                                   //// PAVO 认证服务API : 验证码 : HEADER不需要Token
    case QueryUserInfo
    case CheckVersion(version:String)           // 检查App版本
    case QueryUserTags                          //用户标签
    case UpdateUserTags                         //更新用户标签
    case VerifyPassWord                         //验证原始密码
    case ChangePassWord                         //修改密码
    case VIPUsers                               /////白名单用户
    case DeleteVIPUser                          /////删除白名单用户 
    case AddWhiteUser                           ////增加白名单用户
    
    var description: String {
      switch self {
      case .ApiURL(let path):                   return "/api/\(path)"
      case .LoginPhone:                         return "/pav/sso/token/v1/phone/ss"
      case .LoginUserName:                      return "/pav/sso/token/v1/name/ss"
      case .Token:                              return "/pav/sso/token/v1"
      case .DeleteToken:                        return "/pav/sso/token/v1"
      case .Code :                              return "/pav/sso/vcode/v1/ss?source=login"
      case .QueryUserInfo:                      return "/res/v1/query/si/all"
      case .CheckVersion(let version):          return "/for/res/v1/systempub/upgrade/newestversion/1/IOS/\(version)"
      case .QueryUserTags:                      return "/for/res/v1/query/user/tags"
      case.UpdateUserTags:                      return "/for/res/v1/update/user/tags"
      case.VerifyPassWord:                      return "/for/res/v1/verify/ss/loginpassword"
      case.ChangePassWord:                      return "/for/res/v1/update/ss/loginpassword"
      case.VIPUsers:                            return "/for/res/v1/whiteuser/info"
      case.DeleteVIPUser:                       return "/for/res/v1/whiteuser"
      case.AddWhiteUser:                        return "for/res/v1/whiteuser"
      }
    }
  }
  
  func jsonFromData(jsonData:NSData?) -> NSDictionary?  {
    guard let jsonData = jsonData else {
      return nil
    }
    guard let parsed = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary else {
      return nil
    }
    return parsed
  }
  
  func put(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.PUT, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  
  func post(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.POST, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  
  func get(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.GET, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  
  func delete(urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    requestAPI(.DELETE, urlString: urlString, parameters: parameters, tokenRequired: tokenRequired) { (json, err) -> Void in
      if let err = err {
        completionHandler(json, err)
      } else {
        completionHandler(json, nil)
      }
    }
  }
  
  //HTTP REQUEST
  func requestAPI(method: Method, urlString: String, parameters: [String : AnyObject]? ,tokenRequired:Bool = true, completionHandler: ((JSON?, NSError?) -> Void)) {
    
    var headers = ["Content-Type":"application/json"]
    if let token = TokenPayload.sharedInstance.token  where !token.isEmpty {
      print("request with token:\(token)")
      headers["Token"] = token
    } else {
      if tokenRequired {
        print("********* Token is required for [\(method)][\(urlString)] **********")
        return
      }
    }
    
    print(urlString)
    print(parameters)
    
    request(method, urlString, parameters: parameters, encoding: method == .GET ? .URLEncodedInURL : .JSON, headers: headers).response { (req, res, data, error) -> Void in
      print("statusCode:\(res?.statusCode) for url: \(res?.URL?.absoluteString)")
      guard let statusCode = res?.statusCode else{
        let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
          code: 0,
          userInfo: ["res":"0","resDesc":"未知网络错误:)"])
        completionHandler(nil,e)
        return
      }
      if statusCode == 401 {//token过期
        // 由于异步请求，其他请求在token刷新后立即到达server会被判定失效，导致用户被登出
        // 2016-04-21: 刷新token改为非异步方式 
        //if NSDate().timeIntervalSince1970 > self.refreshTokenTime + 30 {
          print("invalid token:\(req)")
          TokenPayload.sharedInstance.clearCacheTokenPayload()
          NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGOUTCHANGE, object: nil)
        //}
        
        let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
          code: 401,
          userInfo: ["res":"401","resDesc":"invalid token"])
        
        completionHandler(nil,e)
        return
        
      } else if statusCode != 200 {
        let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
          code: statusCode,
          userInfo: ["res":"\(statusCode)","resDesc":"Http请求错误:\(statusCode)"])
        completionHandler(nil,e)
        return
      }
      
      if let error = error {
        print("api request fail [res code:,\(res?.statusCode)]:\(error)")
        completionHandler(nil,error)
      } else {
        print(self.jsonFromData(data))
        
        if let data = data {
          let json = JSON(data: data)
          if json["res"].int == 0 {
            completionHandler(json,nil)
            print(json["resDesc"].string)
          } else {
            var resDesc = ""
            if let key = json["res"].int {
              resDesc = ZKJSErrorMessages.sharedInstance.errorString("\(key)") ?? (json["resDesc"].string != nil ? json["resDesc"].string! : "错误码:\(key)")
            }
            if let key = json["res"].int where key == 6 || key == 8 {//token过期
              NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGOUTCHANGE, object: nil)
            }
            let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
              code: json["res"].int ?? -1,
              userInfo: ["res":"\(json["res"].int)","resDesc":resDesc])
            completionHandler(json,e)
            print("error with reason: \(json["resDesc"].string)")
            if let key = json["res"].int,
              let msg = ZKJSErrorMessages.sharedInstance.errorString("\(key)") {
              //ZKJSTool.showMsg(msg)
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

}