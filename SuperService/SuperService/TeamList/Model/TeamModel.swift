//
//  TeamModel.swift
//  SuperService
//
//  Created by admin on 15/10/21.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

struct TeamModel {

  var username: String?
  var phone: String?
  var roleid: Int?
  var realname: String?
  var email: String?
  var rolename: String?
  var sex:Int?
  var userimage: String?
  var roledesc: String?
  var userid: String?
  var displayRoleName:String {
    let r = rolename ?? "#"
    return r.isEmpty ? "#" : r
  }
  var roleCharacter: String {
    return self.displayRoleName.firstCharactor
  }
  var avatarURL: String {
    guard let userimage = userimage else { return "" }
    return userimage.avatarURL
  }
  var avatarUrlFullSize: String {
    guard let userimage = userimage else { return "" }
    return userimage.fullImageUrl
  }

  init(dic:JSON){
    if let name = dic["username"].string {
      self.username = name
    } else if let name = dic["username"].number {
      self.username = name.stringValue
    }
    phone = dic["phone"].string ?? ""
    realname = dic["realname"].string ?? ""
    sex = dic["sex"].int
    userimage = dic["userimage"].string ?? ""
    userid = dic["userid"].string ?? ""
    roledesc = dic["roledesc"].string ?? ""
    email = dic["email"].string ?? ""
    rolename = dic["rolename"].string ?? ""
    roleid = dic["roleid"].int ?? 0
    
   
  }

}

extension TeamModel: Equatable {
}

func ==(lhs: TeamModel, rhs: TeamModel) -> Bool {
  return lhs.userid == rhs.userid
}
