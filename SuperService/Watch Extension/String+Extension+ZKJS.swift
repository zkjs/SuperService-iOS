//
//  String+Extension+ZKJS.swift
//  SuperService
//
//  Created by Qin Yejun on 4/13/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension String {
  var fullImageUrl: String {
    return ZKJSConfig.sharedInstance.BaseImageURL.stringByTrimmingCharactersInSet(
      NSCharacterSet(charactersInString: "/")
      )  + "/" + self.stringByTrimmingCharactersInSet(
        NSCharacterSet(charactersInString: "/")
    )
  }
  
  var fullUrl:String {
    return ZKJSConfig.sharedInstance.BaseURL.stringByTrimmingCharactersInSet(
      NSCharacterSet(charactersInString: "/")
      ) + "/" + self.stringByTrimmingCharactersInSet(
        NSCharacterSet(charactersInString: "/")
    )
  }
  
  var md5: String {
    let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
    
    CC_MD5(str!, strLen, result)
    
    let hash = NSMutableString()
    for i in 0..<digestLen {
      hash.appendFormat("%02x", result[i])
    }
    
    result.dealloc(digestLen)
    
    return String(format: hash as String)
  }
}