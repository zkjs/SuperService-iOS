//
//  HttpService+CallServiceTask.swift
//  SuperService
//
//  Created by AlexBang on 16/6/23.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import Foundation

enum TaskAction:Int {
  case LaunchMission = 1 //发起任务
  case Assign            //指派
  case Ready             //就绪
  case Cancle            //取消
  case Complete          //完成
  case Evaluate          //评价
}
extension HttpService {
  //获取呼叫服务任务列表
  func getCallServicelist(taskid:String, completionHandler:([CallServiceModel]?,NSError?) -> ()) {
    let url = ResourcePath.CallServerTask.description.fullUrl
    var dic = [String:String]()
    if !taskid.isEmpty {
      dic = ["taskid":taskid]
    }
    get(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"].array where data.count > 0 {
          var services = [CallServiceModel]()
          for userData in data {
            let user = CallServiceModel(dic: userData)
            services.append(user)
          }
          print(services.count)
          completionHandler(services,nil)
        } else {
          completionHandler([],nil)
        }
      }
    }
  }
  
  //操作呼叫服务更改状态
  func servicetaskStatusChange(taskid:String,operationseq:String,taskaction:Int,completionHandler:(JSON?,NSError?) -> ()) {
    let url = ResourcePath.ServicetaskStatusChange.description.fullUrl
    let dic = ["taskid":taskid,"operationseq":operationseq,"taskaction":taskaction]
    put(url, parameters: dic as? [String : AnyObject]) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"] {
          completionHandler(data,nil)
        }
      }
      
    }
  }
  
  //操作呼叫服务任务追踪
  func servicetaskDetail(taskid:Int,completionHandler:(JSON?,NSError?) -> ()) {
    let url = ResourcePath.ServicetaskDetail.description.fullUrl
    let dic = ["taskid":taskid]
    get(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let task = json?["data"] {
          completionHandler(task,nil)
        }
      }
    }
  }
  
  //获取商家部门信息
  
  func rolesWithshops(completionHandler:([RolesWithShopModel]?,NSError?) -> ()) {
    let url = ResourcePath.RolesFromShop.description.fullUrl
    get(url, parameters: nil) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let datas = json?["data"].array where datas.count > 0 {
          var roles = [RolesWithShopModel]()
          for a in datas {
            let role =  RolesWithShopModel(dic:a)
            roles.append(role)
          }
          completionHandler(roles,nil)
        } else {
          completionHandler([],nil)
        }
      }
    }
  }
  
  //获取呼叫服务标签列表
  func servicetags(locid:String,completionHandler:([ServicetagFirstModel]?,NSError?) -> ()) {
    let url = ResourcePath.Servicetag.description.fullUrl
    var dic = [String:String]()
    if !locid.isEmpty {
      dic = ["locid":locid]
    }
    get(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let task = json?["data"].array where task.count > 0 {
          var servicetags = [ServicetagFirstModel]()
          for a in task {
            let user = ServicetagFirstModel(dic: a)
            servicetags.append(user)
          }
          completionHandler(servicetags,nil)
        } else {
          completionHandler([],nil)
        }
      }
    }
  }
  
  //添加一级服务标签
  
  func addFirstserviceTag(firstSrvTagName:String,roleids:NSArray,ownerids:NSArray,locids:NSArray, completionHandler:(JSON?,NSError?) -> ()) {
    let url = ResourcePath.Addfirstsrvtag.description.fullUrl
    let dic = ["firstSrvTagName":firstSrvTagName,"roleids":roleids,"ownerids":ownerids,"locids":locids]
    post(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["data"] {
        completionHandler(data,nil)
      }
    }
   }
 }
  
  //添加二级服务标签
  
  func addSecondServiceTag(firstSrvTagId:String,secondSrvTagName:String,completionHandler:(ServicetagSecondmodel?,NSError?) -> ()) {
    let url = ResourcePath.Addsecondsrvtag.description.fullUrl
    let dic = ["firstSrvTagId":firstSrvTagId,"secondSrvTagName":secondSrvTagName]
    post(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let success = json?["resDesc"] {
          if success == "success" {
            if let data = json?["data"] {
              let servicetag = ServicetagSecondmodel(json:data)
              completionHandler(servicetag,nil)
            }
          } 
        }
      }
    }
  }
  
  //删除一级服务标签（二级同时删除），删除二级服务标签
  func deleteFirstAndSecondTag(secondsrctagid:String,firstsrvtagid:String,completionHandler:(JSON?,NSError?) -> ()) {
    let url = ResourcePath.Deletesrvtag.description.fullUrl
    var dic = [String:String]()
    if secondsrctagid == "" {
       dic = ["firstsrvtagid":firstsrvtagid]
    } else {
       dic = ["secondsrctagid":secondsrctagid]
    }
    
    delete(url, parameters: dic) { (json, error) in
      if let error = error {
        completionHandler(nil,error)
      } else {
        if let data = json?["resDesc"] {
          completionHandler(data,nil)
        }
      }
    }
  }
}