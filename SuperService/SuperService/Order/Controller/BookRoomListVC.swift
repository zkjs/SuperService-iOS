//
//  BookRoomListVC.swift
//  SuperService
//
//  Created by Hanton on 1/7/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

typealias RoomSelectionBlock = (RoomGoods) -> ()

class BookRoomListVC: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  
  var shopid: String!
  var shopName: String!
  var dataArray = NSMutableArray()
  var roomTypes = NSMutableArray()
  var selection: RoomSelectionBlock?
  private var filtedArray = NSMutableArray()
  private var selectedRow : Int = -1  // 默认不选
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("BookRoomListVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
    loadRoomTypes()
  }
  
  func loadRoomTypes() {
    ZKJSJavaHTTPSessionManager.sharedInstance().getShopGoodsListWithShopID(shopid, success: { [unowned self] (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      print(responseObject)
      if let arr = responseObject as? NSArray {
        for dict in arr {
          if let myDict = dict as? NSDictionary {
            let goods = RoomGoods(dic: myDict)
            self.roomTypes.addObject(goods)
          }
        }
        self.tableView.reloadData()
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  private func setUI() {
    tableView.tableFooterView = UIView()
    
    let nibName = UINib(nibName: BookRoomCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: BookRoomCell.reuseIdentifier())
  }
  
}

// MARK: - Table View

extension BookRoomListVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.roomTypes.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return BookRoomCell.height()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(BookRoomCell.reuseIdentifier()) as! BookRoomCell
    if indexPath.row == selectedRow {
      tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
    }
    cell.setData(roomTypes[indexPath.row] as! RoomGoods)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView .deselectRowAtIndexPath(indexPath, animated: true)
    let goods = roomTypes[indexPath.row] as! RoomGoods
    if (selection != nil){
      selection!(goods)
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
}
