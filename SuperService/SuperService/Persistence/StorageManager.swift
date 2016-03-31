//
//  StorageManager.swift
//  SVIP
//
//  Created by Hanton on 7/4/15.
//  Copyright (c) 2015 zkjinshi. All rights reserved.
//

import UIKit
private let KHistoryArray = "HistoryArray.archive"
private let kBeaconRegions = "BeaconRegions.archive"
private let kLastOrder = "LastOrder.archive"
private let kShopsInfo = "Shops.archive"
private let kHomeImages = "HomeImage.archive"
private let kCachedBeaconRegions = "CachedBeaconRegions.archive"

class StorageManager: NSObject {
  
  class func sharedInstance() -> StorageManager {
    struct Singleton {
      static let instance = StorageManager()
    }
    return Singleton.instance
  }
  
  func documentDirectory() -> NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
  }
  
  func saveHomeImages(images: UIImage,userID:String) {
    let path = documentDirectory().stringByAppendingPathComponent(userID)
    NSKeyedArchiver.archiveRootObject(images, toFile: path)
  }
  
  func homeImage(userID:String) -> UIImage? {
    let path = documentDirectory().stringByAppendingPathComponent(userID)
    let image = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? UIImage
    return image
  }
  
  func saveLocids(locids:NSArray) {
    let path = documentDirectory().stringByAppendingPathComponent("array.archive")
    NSKeyedArchiver.archiveRootObject(locids, toFile: path)
  }
  
  func noticeArray() -> [String]? {
    let path = documentDirectory().stringByAppendingPathComponent("array.archive")
    let noticeArray = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String]
    return noticeArray
  }
  
  func clearNoticeArray() {
    let path = documentDirectory().stringByAppendingPathComponent("array.archive")
    if !path.isEmpty {
      let mgr = NSFileManager.defaultManager()
      try! mgr.removeItemAtPath(path)
    }
   
  }
  
  
  
}
