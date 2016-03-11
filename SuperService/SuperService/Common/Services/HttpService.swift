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
  static let ImageURL = "http://svip02.oss-cn-shenzhen.aliyuncs.com"  // 图片服务器
  
  // 测试
  static let baseURL = "http://tst.zkjinshi.com/"  // PHP服务器
  static let baseURLJava = "http://test.zkjinshi.com/japi/"  // Java服务器
  static let EaseMobAppKey = "zkjs#svip"  // 环信
  
  // 预上线
  /*
  private static let baseURL = "http://rap.zkjinshi.com/"  // PHP服务器
  private static let baseURLJava = "http://p.zkjinshi.com/japi/"  // Java服务器
  private static let EaseMobAppKey = "zkjs#sid"  // 环信
  */
  
  // 正式
  /*
  private static let baseURL = "http://api.zkjinshi.com/"  // PHP服务器
  private static let baseURLJava = "http://mmm.zkjinshi.com/"  // Java服务器
  private static let EaseMobAppKey = "zkjs#prosvip"  // 环信
  */
  
  private static let baseCodeURL = "http://p.zkjinshi.com/test/pav"
   static let BaseURL = "http://p.zkjinshi.com/test/for/"
//    private static let baseCodeURL = "http://192.168.199.112:8082" //局域网测试IP
  static let baseRegisterURL = "http://120.25.80.143:8083" // 注册地址
  
  
  private enum ResourcePath: CustomStringConvertible {
    case ApiURL(path:String)
    case LoginPhone                             //// PAVO 认证服务API : 使用手机号&验证码登录
    case LoginUserName                          //// PAVO 认证服务API : 使用用户名和密码登录
    case Code                             // PAVO 认证服务API : 验证码 : HEADER不需要Token
    
    case QueryUserInfo
    
    var description: String {
      switch self {
      case .ApiURL(let path): return "/api/\(path)"
      case .LoginPhone: return "/sso/token/v1/phone/ss"
      case .LoginUserName: return "/sso/token/v1/name/ss"
        case .Code : return "/sso/vcode/v1/ss?source=login"
        case.QueryUserInfo: return "/res/v1/query/si/all"
     
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
    let urlString = baseURL + ResourcePath.ApiURL(path: "test").description
    
    let parameters = ["param1":param1,"param2":param2]
    
    requestAPI(.POST, urlString: urlString, parameters: parameters) { (json, err) -> Void in
      completionHandler(json,err)
    }
  }
  
  
  //// PAVO 认证服务API : 验证码 : HEADER不需要Token
  static func requestSmsCodeWithPhoneNumber(phone:String,completionHandler:(JSON?, NSError?) -> ()){
    let urlString = baseCodeURL + ResourcePath.Code.description
    let key = "X2VOV0+W7szslb+@kd7d44Im&JUAWO0y"
    let data: NSData = phone.dataUsingEncoding(NSUTF8StringEncoding)!
    let encryptedData = data.AES256EncryptWithKey(key).base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    let dict = ["phone":"\(encryptedData)"]
    post(urlString, parameters: dict,tokenRequired: false) { (json, error) -> Void in
      completionHandler(json,error)
    }
    
  }

  
  //// PAVO 认证服务API : 使用手机验证码创建Token : HEADER不需要Token
  static func loginWithPhone(code:String,phone:String,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = baseCodeURL + ResourcePath.LoginPhone.description
    
    let dict = ["phone":"\(phone)","code":"\(code)"]
    post(urlString, parameters: dict,tokenRequired: false) { (json, error) -> Void in
      if let json = json {
        guard let token = json["token"].string else {
          print("no token")
          return
        }
        print("success token:\(token)")
        let tokenPayload = TokenPayload.sharedInstance
        tokenPayload.saveTokenPayload(token)
        
        //登录成功后订阅云巴推送
        if let userID = tokenPayload.userID {
          print("userID:\(userID)")
          YunbaSubscribeService.sharedInstance.subscribeAllChannels()
          YunbaSubscribeService.sharedInstance.setAlias(userID)
        }
      } else {
        
      }
      
      completionHandler(json, error)
    }
  }
  
  //// PAVO 认证服务API : 使用用户名和密码 : HEADER不需要Token
  static func loginWithUserName(username:String,password:String,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = baseCodeURL + ResourcePath.LoginUserName.description
    
    let dict = ["username":"\(username)","password":"\(password)"]
    post(urlString, parameters: dict, tokenRequired: false) { (json, error) -> Void in
      if let json = json {
        guard let token = json["token"].string else {
          print("no token")
          return
        }
        let tokenPayload = TokenPayload.sharedInstance
        tokenPayload.saveTokenPayload(token)
        
        //登录成功后订阅云巴推送
        if let userID = tokenPayload.userID {
          print("userID:\(userID)")
          YunbaSubscribeService.sharedInstance.subscribeAllChannels()
          YunbaSubscribeService.sharedInstance.setAlias(userID)
        }
      } else {
        
      }
      
      completionHandler(json, error)
    }
  }
  

  


}