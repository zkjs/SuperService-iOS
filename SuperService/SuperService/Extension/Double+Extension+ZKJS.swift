//
//  Double+Extension+ZKJS.swift
//  SuperService
//
//  Created by Qin Yejun on 3/11/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension Double {
  func format(f: String) -> String {
    return NSString(format: "%\(f)f", self) as String
  }
}