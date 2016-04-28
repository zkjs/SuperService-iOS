//
//  HttpService+GetCode.swift
//  SuperService
//
//  Created by AlexBang on 16/3/11.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  
 
  private enum CodeSource: CustomStringConvertible {
    case AddCode                     // 获取邀请码
    case CodeList(type:Int)          // 通过userid获取邀请码及关联的客户
    case CodeLink                    // 生成分享宣传链接

    
    var description: String {
      switch self {
      case.AddCode:                  return "/for/res/v1/salecode/get/salecode"
      case.CodeList(let type):       return "/for/res/v1/salecode/salecodewithsi/\(type)"
      case.CodeLink:                 return "/for/res/v1/link/joinpage"

        
      }
    }
 }
  
  /////单个添加邀请码
  func addSingleCode(rmk:String, completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = CodeSource.AddCode.description.fullUrl
    let dic = ["rmk":rmk]
    post(urlString, parameters: dic) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  func getCodeList(type:Int,page:Int,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = CodeSource.CodeList(type: type).description.fullUrl
    let dic = ["type":type,"page":page,"page_size":HttpService.DefaultPageSize]
    get(urlString, parameters: dic) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  func generateCodeLink(completionHandler:(JSON?,NSError?) -> ()) {
  let urlString = CodeSource.CodeLink.description.fullUrl
  get(urlString, parameters: nil) { (json, error) -> Void in
  if let error = error {
    completionHandler(nil,error)
  } else {
    completionHandler(json,nil)
      }
   }
  }

  func queryUsertags(userid:String,completionHandler: (TagsModel?,NSError?)->Void) {
    let urlString = ResourcePath.QueryUserTags.description.fullUrl
    let param = ["si_id":userid]
    get(urlString, parameters: param) { (json, error) -> Void in
     if let error = error {
          completionHandler(nil,error)
        } else {
          if let data = json?["data"]
          {
            let user = TagsModel(dic: data)
            completionHandler(user,nil)
          }
        }
      }
    }
  }
  