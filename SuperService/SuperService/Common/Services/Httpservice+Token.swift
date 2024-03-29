//
//  Httpservice+Token.swift
//  SuperService
//
//  Created by Qin Yejun on 3/11/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension HttpService {
  
  //// PAVO 认证服务API : Token管理 :
  func refreshToken(completionHandler:HttpCompletionHandler?) {
    let urlString = ResourcePath.Token.description.fullUrl
    
    put(urlString, parameters: nil) { (json, error) -> Void in
      completionHandler?(json, error)
      if let _ = error {
       NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGOUTCHANGE, object: nil)
      }
      if let json = json {
        guard let token = json["token"].string else {
          print("no token")
          NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGOUTCHANGE, object: nil)
          return
        }
        print("refresh token success:\(token)")
        TokenPayload.sharedInstance.saveTokenPayload(token)
      }
    }
  }
  
  //// PAVO 认证服务API : Token管理 : 同步方式刷新Token
  func refreshTokenSync() -> Bool {
    guard let token = TokenPayload.sharedInstance.token  where !token.isEmpty else {
      return false
    }
    
    print("refresh token with: \(token)")
    let urlString = ResourcePath.Token.description.fullUrl
    let request = NSMutableURLRequest(URL: NSURL(string:urlString)!)
    request.HTTPMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "Token")
    request.timeoutInterval = 5
    
    var response: NSURLResponse?
    do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
      let json = JSON(data: data)
      print(json["resDesc"].string)
      if json["res"].int == 0 {
        if let token = json["token"].string {
          print("get new token:\n\(token)")
          TokenPayload.sharedInstance.saveTokenPayload(token)
          return true
        }
        return false
      } else {
        return false
      }
    } catch (let error as NSURLError) {
      if error == .TimedOut {
        print("refresh token timeout, use old token")
        return true
      }
      print(error.rawValue)
      return false
    } catch {
      return false
    }
  }
  
  //// PAVO 认证服务API : Token管理 :
  func deleteToken(completionHandler:HttpCompletionHandler) {
    let urlString = ResourcePath.Token.description.fullUrl
    guard   let token = TokenPayload.sharedInstance.token else {return}
    let dic = ["token":token]
    put(urlString, parameters: dic) { (json, error) -> Void in
      completionHandler(json, error)
    }
  }
  
  //// PAVO 认证服务API : 验证码 : HEADER不需要Token
  func requestSmsCodeWithPhoneNumber(phone:String,completionHandler:(JSON?, NSError?) -> ()){
    let urlString = ResourcePath.Code.description.fullUrl
    let key = "X2VOV0+W7szslb+@kd7d44Im&JUAWO0y"
    let data: NSData = phone.dataUsingEncoding(NSUTF8StringEncoding)!
    let encryptedData = data.AES256EncryptWithKey(key).base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    let dict = ["phone":"\(encryptedData)"]
    post(urlString, parameters: dict,tokenRequired: false) { (json, error) -> Void in
      completionHandler(json,error)
    }
    
  }
  
  
  //// PAVO 认证服务API : 使用手机验证码创建Token : HEADER不需要Token
  func loginWithPhone(code:String,phone:String,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = ResourcePath.LoginPhone.description.fullUrl
    
    let dict = ["phone":"\(phone)","code":"\(code)"]
    post(urlString, parameters: dict,tokenRequired: false) { (json, error) -> Void in
      if let json = json {
        guard let token = json["token"].string else {
          print("no token")
          completionHandler(nil, error)
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
  func loginWithUserName(username:String,password:String,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = ResourcePath.LoginUserName.description.fullUrl
    
    let dict = ["username":"\(username)","password":"\(password)"]
    post(urlString, parameters: dict, tokenRequired: false) { (json, error) -> Void in
      if let json = json {
        guard let token = json["token"].string else {
          print("no token")
          completionHandler(nil, error)
          return
        }
        let tokenPayload = TokenPayload.sharedInstance
        tokenPayload.saveTokenPayload(token)
        StorageManager.sharedInstance().usernameAndPasswordLogin("loginWithUserAndpassword")
        
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