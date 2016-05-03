//
//  Gender.swift
//  SuperService
//
//  Created by Qin Yejun on 5/3/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

enum Gender:Int, CustomStringConvertible {
  case Unknown = -1,Female = 0,Male = 1
  
  var description: String {
    switch self {
    case .Female:
      return "女士"
    case .Male:
      return "先生"
    default:
      return ""
    }
  }
}