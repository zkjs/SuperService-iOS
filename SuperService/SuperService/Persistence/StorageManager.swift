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
private let kPresentInfoVC = "PresentInfoVC.archive"

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
    let path = documentDirectory().stringByAppendingPathComponent("userimage."+userID)
    NSKeyedArchiver.archiveRootObject(images, toFile: path)
  }
  
  func homeImage(userID:String) -> UIImage? {
    let path = documentDirectory().stringByAppendingPathComponent("userimage."+userID)
    let image = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? UIImage
    return image
  }
  
  func saveLocids(locids:NSArray) {
    let path = documentDirectory().stringByAppendingPathComponent("array.archive")
    NSKeyedArchiver.archiveRootObject(locids, toFile: path)
  }
  
  func saveBeaconPayLocids(locids:NSArray) {
    let path = documentDirectory().stringByAppendingPathComponent("BeaconPayLocids.archive")
    NSKeyedArchiver.archiveRootObject(locids, toFile: path)
  }
  
  func nearBeaconLocid() -> [String]? {
    let path = documentDirectory().stringByAppendingPathComponent("BeaconPayLocids.archive")
    let BeaconPayArray = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String]
    return BeaconPayArray
  }
  
  func usernameAndPasswordLogin(loginPath:String) {
    let path = documentDirectory().stringByAppendingPathComponent("usernameAndpassword.archive")
    NSKeyedArchiver.archiveRootObject(loginPath, toFile: path)
  }
  
  func ispasswordAndusername() -> String? {
    let path = documentDirectory().stringByAppendingPathComponent("usernameAndpassword.archive")
    let ispasswordAndusername = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? String
    return ispasswordAndusername
  }
  
 
  
  
  
  func noticeArray() -> [String]? {
    let path = documentDirectory().stringByAppendingPathComponent("array.archive")
    let noticeArray = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String]
    return noticeArray
  }
  
  func saveBeaconsInfoFromLocid(beacons:[String:String])  {
    let path = documentDirectory().stringByAppendingPathComponent("BangdingBeacon.archive")
    NSKeyedArchiver.archiveRootObject(beacons , toFile: path)
    
  }
  
  func getBeaconsFromLoicd() -> [String:String]? {
    let path = documentDirectory().stringByAppendingPathComponent("BangdingBeacon.archive")
    let beaconsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String:String]
    return beaconsArray
  }
  
  func savePresentInfoVC(firstPresent:Bool) {
    let path = documentDirectory().stringByAppendingPathComponent(kPresentInfoVC)
    NSKeyedArchiver.archiveRootObject(firstPresent, toFile: path)
  }
  
  func presentsInfoVC() -> Bool? {
    let path = documentDirectory().stringByAppendingPathComponent(kPresentInfoVC)
    let IsPresents = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? Bool
    return IsPresents
  }
  
  func clearNoticeArray() {
    let path = documentDirectory().stringByAppendingPathComponent("array.archive")
    if !path.isEmpty {
      
      let mgr = NSFileManager.defaultManager()
      if mgr.fileExistsAtPath(path) {
      try! mgr.removeItemAtPath(path)
      }
    }
    
   }
  
  func clearnearBeaconLocid(){
    let path = documentDirectory().stringByAppendingPathComponent("BeaconPayLocids.archive")
    if !path.isEmpty {
      let mgr = NSFileManager.defaultManager()
      if mgr.fileExistsAtPath(path) {
        try! mgr.removeItemAtPath(path)
      }
    }
    
  }
  
  func clearloginStatus() {
    let path = documentDirectory().stringByAppendingPathComponent("usernameAndpassword.archive")
    if !path.isEmpty {
      let mgr = NSFileManager.defaultManager()
      if mgr.fileExistsAtPath(path) {
        try! mgr.removeItemAtPath(path)
      }
    }
  }
}
