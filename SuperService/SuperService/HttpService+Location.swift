//
//  HttpService+Location.swift
//  SVIP
//
//  Created by Qin Yejun on 3/7/16.
//  Copyright © 2016 zkjinshi. All rights reserved.
//

import Foundation
import CoreLocation
//import Alamofire
//import SwiftyJSON

extension HttpService {
  
  //// PYXIS 位置服务API : Beacon 位置信息 :
  func sendBeaconChanges(uuid:String, major:String, minor:String, sensorID: String = "", timestamp:Int64, completionHandler:HttpCompletionHandler?){
    let urlString = ResourcePath.Beacon.description.fullUrl
    guard  let token = TokenPayload.sharedInstance.token else {return}
    print(token)
    let dict = ["locid":major,"major":major,"minor":minor,"uuid":uuid,"sensorid":"","timestamp":"\(timestamp)"]
    print(dict)
    
    requestAPI(.PUT, urlString: urlString, parameters: dict,tokenRequired: true) {[unowned self] (json, error) -> Void in
      completionHandler?(json, error);
      if let error = error {
        print("beacon upload fail:\(error)")
      } else {
        print("beacon upload success")
      }
    }
  }
  
  //// PYXIS 位置服务API : GPS 位置信息 :
  func sendGpsChanges(latitude:CLLocationDegrees, longitude:CLLocationDegrees, altitude:CLLocationDistance,  timestamp:Int64, mac:String,ssid:String, completionHandler:HttpCompletionHandler?){
    let urlString = ResourcePath.GPS.description.fullUrl
    
    var dict = ["latitude":latitude.format("0.6"),"longitude":longitude.format("0.6"),"altitude":altitude.format("0.6"), "timestamp":"\(timestamp)"]
    if !mac.isEmpty {
      dict["mac"] = mac
    }
    if !ssid.isEmpty {
      dict["ssid"] = ssid
    }
    
    requestAPI(.PUT, urlString: urlString, parameters: dict, tokenRequired: true) { (json, error) -> Void in
      completionHandler?(json, error);
      if let error = error {
        print("gps upload fail:\(error)")
      } else {
        print("gps upload success")
      }
    }
    
  }
  
  func uploadLogs(filename:String!,file:NSData, completionHandler:HttpCompletionHandler) {
    
  }
  
  func uploadBeacons(beacons:[[String:String]], completionHandler:HttpCompletionHandler?) {
    
  }
}