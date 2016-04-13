//
//  ImageCache.swift
//  SuperService
//
//  Created by Qin Yejun on 4/13/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import WatchKit

class ImageCache {
  static let sharedInstance = ImageCache()
  private var sharedCache: NSCache = {
    print("initial NSCache")
    let cache = NSCache()
    cache.name = "com.zkjinshi.superservice.watch"
    cache.countLimit = 20 // Max 20 images in memory.
    cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
    return cache
  }()
  
  func cacheImageForKey(key:String) -> UIImage? {
    print("get image form cache:\(key)")
    let o = sharedCache.objectForKey(key)
    return sharedCache.objectForKey(key) as? UIImage
  }
  
  func setImageForKey(key:String, imageData:NSData) {
    print("set image to cache:\(key) ")
    sharedCache.setObject(
      UIImage(data: imageData)!,
      forKey: key,
      cost: imageData.length)
  }
}