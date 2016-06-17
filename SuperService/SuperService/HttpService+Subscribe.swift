//
//  HttpService+Subscribe.swift
//  SuperService
//
//  Created by AlexBang on 16/3/15.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation
extension HttpService {
  private enum ResourcePathAccount: CustomStringConvertible {
    case BeaconList                 // 获取商家Beacon列表


    
    
    var description: String {
      switch self {
      case .BeaconList:             return "/for/lbs/v1/loc/beacon"
    

      }
    }
}
  
  func getSubscribeList(page:Int,completionHandler:HttpCompletionHandler){
    let urlString =  ResourcePathAccount.BeaconList.description.fullUrl
    
    let parameters = ["page":page,"page_size":HttpService.DefaultPageSize]
    get(urlString, parameters: parameters) { (json, error) -> Void in
      if let error = error {
        print(error)
        completionHandler(json,error)
      } else {
          completionHandler(json,error)
        }
      }
  }
  
  
}