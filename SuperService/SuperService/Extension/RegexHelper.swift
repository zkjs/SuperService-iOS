//
//  RegexHelper.swift
//  SuperService
//
//  Created by Qin Yejun on 3/11/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

struct RegexHelper {
  let regex: NSRegularExpression?
  init(_ pattern: String) {
    var error: NSError?
    do {
      regex = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    } catch let error1 as NSError {
      error = error1
      regex = nil
    }
  }
  
  func match(input: String) -> Bool {
    if let matches = regex?.matchesInString(input, options: [], range: NSMakeRange(0, input.characters.count)) {
      return matches.count > 0
    } else {
      return false
    }
  }
}

infix operator =~ {
associativity none
precedence 130
}
func =~(lhs: String, rhs: String) -> Bool {
  return RegexHelper(rhs).match(lhs)
}