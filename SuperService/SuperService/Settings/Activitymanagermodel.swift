//
//  Activitymanagermodel.swift
//  SuperService
//
//  Created by AlexBang on 16/6/29.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

struct ActivitymanagerModel {
  var actname:String?
  var actid:Int?
  var startdate:String?
  var enddate:String?
  var invitedpersoncnt:Int?
  var confirmpersoncnt:Int?
  var actcontent:String?
  var actimage:String?
  var acturl:String?
  var maxtake:Int?
  var inviteperson:[InvitepersonModel]?
  
  init(dic:JSON) {
    actid = dic["actid"].int ?? 0
    maxtake = dic["maxtake"].int ?? 0
    actcontent = dic["actcontent"].string ?? ""
    acturl = dic["acturl"].string ?? ""
    actimage = dic["actimage"].string ?? ""
    actname = dic["actname"].string ?? ""
    startdate = dic["startdate"].string ?? ""
    enddate = dic["enddate"].string ?? ""
    invitedpersoncnt = dic["invitedpersoncnt"].int ?? 0
    confirmpersoncnt = dic["confirmpersoncnt"].int ?? 0
    if let  invitepersons = dic["inviteperson"].array {
      var ordersArray = [InvitepersonModel]()
      for o in invitepersons {
        let order = InvitepersonModel(dic: o)
        ordersArray.append(order)
      }
      inviteperson = ordersArray
    } else {
      inviteperson = nil
    }
  }
}


struct InvitepersonModel {
  var userid:String?
  var username:String?
  var takeperson:Int?
  var confirmstatus:String?
  var confirmstatusCode:Int?
  
  init(dic:JSON) {
    userid = dic["userid"].string ?? ""
    username = dic["username"].string ?? ""
    takeperson = dic["takeperson"].int ?? 0
    confirmstatus = dic["confirmstatus"].string ?? ""
    confirmstatusCode = dic["confirmstatusCode"].int ?? 0
  }
}
