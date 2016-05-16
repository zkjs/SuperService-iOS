//
//  HttpService+Password.swift
//  SuperService
//
//  Created by AlexBang on 16/5/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  func userVerifyPassword(originalpassword:String,completionHandler:HttpCompletionHandler) {
    let url = ResourcePath.VerifyPassWord.description.fullUrl
    let dic = ["originalpassword":originalpassword.md5]
    post(url, parameters:dic ) { (json, error) -> Void in
      completionHandler(json,error)
    }
  }
  
  func userChangePassword(originalpassword:String,newpassword:String,completionHandler:HttpCompletionHandler) {
    let url = ResourcePath.ChangePassWord.description.fullUrl
    let dic = ["oldpassword":originalpassword.md5,"newpassword":newpassword.md5]
    post(url, parameters:dic ) { (json, error) -> Void in
      completionHandler(json,error)
    }
  }
}