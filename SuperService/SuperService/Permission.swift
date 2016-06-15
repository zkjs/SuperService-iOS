//
//  Permission.swift
//  SuperService
//
//  Created by Qin Yejun on 6/15/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

enum Permission:String {
  case BTNADDMEMBER     // 团队管理->新建成员按钮	管理员权限
  case BATCHIMPORT      // 团队管理->批量导入Excel	管理员权限
  case DELEMPLOYEE      // 团队管理->删除团队成员	管理员权限
  case CONTACTIMPORT    // 团队管理->通讯录导入	管理员权限
  case MEMBER           // 侧滑栏->会员	销售和管理员权限
  case ADDMEMBER        // 会员->新增会员	销售和管理员权限
  case DELMEMBER        // 会员->侧滑删除	销售和管理员权限
  case MEMBERDETAIL     // 会员详情页->拨打电话（点击电话按钮）	销售和管理员权限
  case CASHREGISTER     // 侧滑栏->收款台	做权限（收银员权限）
  case BTNPOS           // 收款台->收款记录按钮	收银员权限
  case UNKNOWN          // 未知权限
}
