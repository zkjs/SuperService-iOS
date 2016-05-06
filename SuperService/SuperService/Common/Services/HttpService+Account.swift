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
    case UserInfo                 // 获取用户资料
    case UpdateInfo               // 更新用户资料
    case ArrivateData             // 到店通知列表
    case VersionUpgrade           // 版本更新
    case AfterLoginUpdataInfo
    
    
    var description: String {
      switch self {
      case .UserInfo:             return "/for/res/v1/query/user/all"
      case .UpdateInfo:           return "/for/res/v1/register/update/ss"
      case .AfterLoginUpdataInfo: return "/for/res/v1/update/user"
      case .ArrivateData:         return "/pyx/lbs/v1/loc/beacon/"
      case .VersionUpgrade:       return "/res/v1/systempub/upgrade/newestversion/"
      }
    }
  }

  //获取登录用户的资料
  func getUserInfo(completionHandler:HttpCompletionHandler){
    let urlString =  ResourcePathAccount.UserInfo.description.fullUrl
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
  func updateUserInfo(isRegister: Bool, realname:String?,eamil:String?,sex:String?,image:UIImage?, completionHandler:HttpCompletionHandler) {
    if realname == nil && sex == nil && image == nil {
      return
    }
    var urlString = String()
    var parameters = [String:String]()
    if isRegister {
      if let eamil = eamil {
        parameters["eamil"] = eamil
      }
      if let realname = realname {
        parameters["realname"] = realname
      }
      urlString =  ResourcePathAccount.UpdateInfo.description.fullUrl
    } else {
      if let realname = realname {
        parameters["username"] = realname
        urlString =  ResourcePathAccount.AfterLoginUpdataInfo.description.fullUrl
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
            print("statusCode:\(response?.statusCode)")
            guard let statusCode = response?.statusCode else{
              let e = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "com.zkjinshi.svip",
                code: 0,
                userInfo: ["res":"0","resDesc":"未知网络错误:)"])
              completionHandler(nil,e)
              return
            }
            if statusCode == 401 {//token过期
              // 由于异步请求，其他请求在token刷新后立即到达server会被判定失效，导致用户被登出
              if NSDate().timeIntervalSince1970 > self.refreshTokenTime + 100 {
                print("invalid token:\(request)")
                TokenPayload.sharedInstance.clearCacheTokenPayload()
                NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGOUTCHANGE, object: nil)
                return
              }
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
                  if isRegister {//注册更新会返回新的token
                    guard let token = json["token"].string else {
                      return
                    }
                    print(token)
                    let tokenPayload = TokenPayload.sharedInstance
                    tokenPayload.saveTokenPayload(token)
                  } 
                  if let imgUrl = json["data"]["userimage"].string,let userid = json["data"]["userid"].string  where !imgUrl.isEmpty {
                    AccountInfoManager.sharedInstance.saveImageUrl(imgUrl)
                    AccountInfoManager.sharedInstance.saveUserid(userid)
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
                    //ZKJSTool.showMsg("\(key)")
                  }
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
  
  func arrivateList(page:Int,completionHandler:([ArrivateModel]?,NSError?) -> ()) {
    guard let shopid = TokenPayload.sharedInstance.shopid else {return}
    guard let locids :String = AccountInfoManager.sharedInstance.beaconLocationIDs else {return}
    let urlString =  ResourcePathAccount.ArrivateData.description.fullUrl + "/\(shopid)/\(locids)"
    let dic = ["shopid":shopid,"locids":locids,"roles":"USER","page":page,"page_size":HttpService.DefaultPageSize]
    get(urlString, parameters: dic as? [String : AnyObject]) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json {
          var arrviteArr = [ArrivateModel]()
          if let array = data["data"].array {
            for dic in array {
              let arrvite = ArrivateModel(dic: dic)
              arrviteArr.append(arrvite)
            }
          }
          completionHandler(arrviteArr,nil)
        }
        
      }
    }
  }
  
  
  }
