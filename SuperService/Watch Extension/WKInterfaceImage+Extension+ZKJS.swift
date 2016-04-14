//
//  WKInterfaceImage+Extension+ZKJS.swift
//  SuperService
//
//  Created by Qin Yejun on 4/13/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import WatchKit

public extension WKInterfaceImage {
  public func setImageWithUrl(urlString:String, scale: CGFloat = 2.0, placeHolder:UIImage?, completion:((NSData)->Void)?) -> WKInterfaceImage? {
    if let image = ImageCache.sharedInstance.cacheImageForKey(urlString) {
      print("set image frome cached data")
      self.setImage(nil)
      self.setImage(image)
      return self
    } else {
      print("no cache found")
    }
    if let placeHolder = placeHolder {
      self.setImage(placeHolder)
    }
    guard let url = NSURL(string:urlString) else {
      return self
    }
    print("start download image:\(urlString)")
    NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
      if let data = data, let image = UIImage(data: data, scale: scale) {
        print("image loaded:\(urlString)")
        
        dispatch_async(dispatch_get_main_queue()) {
          ImageCache.sharedInstance.setImageForKey(urlString, imageData: data)
          self.setImage(nil)
          self.setImage(image)
          completion?(data)
        }
      } else {
        print("load image error:\(error)")
      }
      }.resume()
    
    return self
  }
  
}


