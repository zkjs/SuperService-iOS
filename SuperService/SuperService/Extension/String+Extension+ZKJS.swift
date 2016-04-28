//
//  String+Extension+ZKJS.swift
//  SuperService
//
//  Created by Qin Yejun on 3/11/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension String {
  var md5 : String{
    let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
    
    CC_MD5(str!, strLen, result);
    
    let hash = NSMutableString();
    for i in 0 ..< digestLen {
      hash.appendFormat("%02x", result[i]);
    }
    result.destroy();
    
    return String(format: hash as String)
  }
  
  var trim: String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  
  var isEmail: Bool {
    return (self =~ "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$")
  }
  
  var isDecimal: Bool {
    return (self =~ "^([0-9]+)(\\.[0-9]{1,2})?$")
  }
  
  
  // Slower version
  func repeatString(n: Int) -> String {
    return Array(count: n, repeatedValue: self).joinWithSeparator("")
  }
  
  // Faster version
  // benchmarked with a 1000 characters and 100 repeats the fast version is approx 500 000 times faster :-)
  func `repeat`(n:Int) -> String {
    var result = self
    for _ in 1 ..< n {
      result += self
    }
    return result
  }
  
  var isMobile: Bool {
    return (self =~ "^0?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$")
  }
  
  var isValidName: Bool {
    return (self =~ "^[\\u4e00-\\u9fa5]+$")
  }
  
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
}


extension String {
  var firstCharactor: String{
    
    //转成了可变字符串
    let str = NSMutableString(string: self)
    //先转换为带声调的拼音
    CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
    //再转换为不带声调的拼音
    CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
    //转化为大写拼音
    let pinYin = str.capitalizedString
    
    //获取并返回首字母
    return pinYin.substringToIndex(pinYin.startIndex.advancedBy(1))
    
  }
}