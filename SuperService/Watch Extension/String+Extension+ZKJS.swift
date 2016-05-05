//
//  String+Extension+ZKJS.swift
//  SuperService
//
//  Created by Qin Yejun on 4/13/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import Foundation

extension String {
  
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
  
  /*
   * 图片完整URL(无适配): Endpoint + ResourcePath
   */
  var fullImageUrl: String {
    return ZKJSConfig.sharedInstance.BaseImageCDNURL.stringByTrimmingCharactersInSet(
      NSCharacterSet(charactersInString: "/")
      )  + "/" + self.stringByTrimmingCharactersInSet(
        NSCharacterSet(charactersInString: "/")
    )
  }
  
  /*
   * 图片完整URL(根据设备尺寸适配): Endpoint + ResourcePath
   */
  var fullImageUrlFitted: String {
    return ZKJSConfig.sharedInstance.BaseImageURL.stringByTrimmingCharactersInSet(
      NSCharacterSet(charactersInString: "/")
      )  + "/" + self.stringByTrimmingCharactersInSet(
        NSCharacterSet(charactersInString: "/")
    )
  }
  
  /*
   * 完整URL: Endpoint + ResourcePath
   */
  var fullUrl:String {
    return ZKJSConfig.sharedInstance.BaseURL.stringByTrimmingCharactersInSet(
      NSCharacterSet(charactersInString: "/")
      ) + "/" + self.stringByTrimmingCharactersInSet(
        NSCharacterSet(charactersInString: "/")
    )
  }
  
  /*
   * 根据设备尺寸返回相应尺寸的图片: 比如 path/file.png => path/file.png@1080w
   */
  var fittedImage: String {
    if self.isEmpty {
      return ""
    }
    return "\(self)@300w"
  }
  
  /*
   * 根据设备尺寸返回相应尺寸图片的完整URL: Endpoint + ResourcePath
   */
  var fittedImageUrl: String {
    return fittedImage.fullImageUrlFitted
  }
  
  /*
   * 根据指定尺寸返回相应图片: 比如 path/file.png => path/file.png@200w_300h_2e
   * ref: http://zbox.zkjinshi.com/doc-view-50.html
   */
  func fullImageUrlWith(width width:Int = 0, height:Int = 0, scale: Bool = false) -> String {
    if self.isEmpty {
      return ""
    }
    var url = self
    if width > 0 && height > 0 {
      url = self + "@\(width)w_\(height)h"
      if scale {
        url += "_2e"
      }
    } else if width > 0 {
      url = self + "@\(width)w"
    } else if height > 0 {
      url = self + "@\(height)h"
    }
    return url.fullImageUrlFitted
  }
  
  var avatarURL: String {
    if self.isEmpty {
      return ""
    }
    return self.fullImageUrlWith(width: 160, height: 160)
  }
  
}