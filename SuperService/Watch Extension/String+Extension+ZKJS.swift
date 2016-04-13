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
}