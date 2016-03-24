//
//  PayheadReusableView.swift
//  SuperService
//
//  Created by AlexBang on 16/3/10.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit
typealias sendValueClosure = (phoneNumber:String)->Void

class PayheadReusableView: UICollectionReusableView {
  var customClosure:sendValueClosure?
  @IBOutlet weak var searchPhone: UISearchBar!
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    guard let phone = searchPhone.text else{return}
    customClosure?(phoneNumber: phone)
  }
  
  
}
