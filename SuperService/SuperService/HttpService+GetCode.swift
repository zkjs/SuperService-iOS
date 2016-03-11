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
    case AddCode
    case CodeList
    case CodeLink

    
    var description: String {
      switch self {
      case.AddCode: return "/res/v1/salecode/get/salecode"
      case.CodeList: return "/res/v1/salecode/salecodewithsi/"
      case.CodeLink: return "/res/v1/link/joinpage"

        
      }
    }
 }
  
  /////单个添加邀请码
  static func addSingleCode(rmk:String, completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = BaseURL + CodeSource.AddCode.description
    let dic = ["rmk":rmk]
    post(urlString, parameters: dic) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  static func getCodeList(type:Int,page:Int,completionHandler:(JSON?,NSError?) -> ()) {
    let urlString = BaseURL + CodeSource.CodeList.description + "\(type)"
    let dic = ["type":type,"page":page,"page_size":10]
    get(urlString, parameters: dic) { (json, error) -> Void in
      if let error = error {
        completionHandler(nil,error)
      } else {
        completionHandler(json,nil)
      }
    }
  }
  
  static func generateCodeLink(completionHandler:(JSON?,NSError?) -> ()) {
  let urlString = BaseURL + CodeSource.CodeLink.description
  get(urlString, parameters: nil) { (json, error) -> Void in
  if let error = error {
  completionHandler(nil,error)
  } else {
  completionHandler(json,nil)
      }
   }
  }

  
  

}