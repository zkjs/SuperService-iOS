//
//  HttpServiceForOC.swift
//  SuperService
//
//  Created by AlexBang on 16/5/6.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation

@objc class HttpServiceForOC:NSObject {
  //获取登录用户的资料
  static func getUserInfo(userid:String,completionHandler: (AnyObject?, NSError?) -> Void){
    let urlString =  "/for/res/v1/query/user/all".fullUrl
    let parameters = ["userids":userid]
    
    var headers = ["Content-Type":"application/json"]
    headers["Token"] = TokenPayload.sharedInstance.token

    
    print(urlString)
    print(parameters)
    
    request(.GET, urlString, parameters: parameters, encoding: .URLEncodedInURL, headers: headers).response { (req, res, data, error) -> Void in
      print("statusCode:\(res?.statusCode) for url: \(res?.URL?.absoluteString)")

      if let error = error {
        print("api request fail [res code:,\(res?.statusCode)]:\(error)")
        completionHandler(nil,error)
      } else {
        completionHandler(data,nil)
      }
    }
  }
}