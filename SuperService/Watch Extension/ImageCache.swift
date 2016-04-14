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
    cache.countLimit = 100 // Max 100 images in memory.
    cache.totalCostLimit = 100*1024*1024 // Max 100MB used.
    return cache
  }()
  
  private var documentDirectory: NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
  }
  
  private func cachedFileNameForKey(key:String) -> String? {
    /*let path = key.characters.split{$0 == "/"}.map(String.init)
    guard let filename = path.last where !filename.isEmpty else {
      return nil
    }
    return filename*/
    return key.md5 + "." + (key as NSString).pathExtension
  }
  
  func cacheImageForKey(key:String) -> UIImage? {
    if let c = sharedCache.objectForKey(key) as? UIImage {
      print("get image form mem cache:\(key)")
      return c
    }
    if let file = imageFromDisk(key) {
      if let data = UIImagePNGRepresentation(file) {
        setImageForKey(key, imageData: data)
      }
      return file
    }
    return nil
  }
  
  func setImageForKey(key:String, imageData:NSData) {
    print("set image to cache:\(key) ")
    guard let image = UIImage(data: imageData) else {
      return
    }
    sharedCache.setObject(
      image,
      forKey: key,
      cost: imageData.length)
    saveImageToDisk(image, key: key)
  }
  
  
  private func saveImageToDisk(image: UIImage,key:String) {
    guard let fileName = cachedFileNameForKey(key) else {
      return
    }
    let path = documentDirectory.stringByAppendingPathComponent(fileName)
    NSKeyedArchiver.archiveRootObject(image, toFile: path)
  }
  
  private func imageFromDisk(key:String) -> UIImage? {
    guard let fileName = cachedFileNameForKey(key) else {
      return nil
    }
    let path = documentDirectory.stringByAppendingPathComponent(fileName)
    let image = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? UIImage
    if image != nil {
      print("get image from disk:\(path)")
    }
    return image
  }
}