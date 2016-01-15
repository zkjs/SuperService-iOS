//
//  InformVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class InformVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
  
  @IBOutlet weak var tableView: UITableView!
  var dic:NSDictionary!
  var noticeArray = [NSNumber]()
  var str:String!
  var areaArray = [AreaModel]()
  var locID = (String)()
  var selectedArray = [Int]()
  var areaArr = [String]()
  var dismissWhenFinished = false
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("InformVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "选择通知区域"
    navigationController?.navigationBarHidden = false
    let nibName = UINib(nibName: InformCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: InformCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    GetWholeAreaOfTheBusinessList()
    let nextStepButton = UIBarButtonItem(image: UIImage(named: "ic_qianjin"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: "nextStep")
    navigationItem.rightBarButtonItem = nextStepButton
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  func GetWholeAreaOfTheList() {
    ZKJSHTTPSessionManager.sharedInstance().WaiterGetAreaOfTheBusinessListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? NSArray {
        var arr = [NSNumber]()
        for dic in array {
          let notice = NoticeModel(dic:dic as! [String:AnyObject])
          arr.append(notice.locid!)
        }
         self.noticeArray = arr
        print(self.noticeArray)
        self.initSelectedArray()  // Model
        self.tableView.reloadData()  // UI
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  func initSelectedArray() {
    for index in 0..<areaArray.count {
      if noticeArray.contains(areaArray[index].locid!) {
        selectedArray.append(index)
      }
    }
  }
  
  func GetWholeAreaOfTheBusinessList() {
    ZKJSHTTPSessionManager.sharedInstance().WaiterGetWholeAreaOfTheBusinessListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? NSArray {
        var datasource = [AreaModel]()
        for dic in array {
          let area = AreaModel(dic: dic as! [String: AnyObject])
          datasource.append(area)
        }
        self.areaArray = datasource
        self.GetWholeAreaOfTheList()
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  //MARK: - Table View Data Source
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return areaArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("InformCell", forIndexPath: indexPath) as! InformCell
    let area = areaArray[indexPath.row]
    cell.selectedButton.addTarget(self, action: "tappedCellSelectedButton:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.selectedButton.tag = indexPath.row
    if noticeArray.contains(area.locid!) {
      cell.isUncheck = false
      cell.selectedButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    }
    
    cell.setData(area)
    return cell
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return InformCell.height()
  }
  
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.frame = CGRectMake(30, 108, 280, 40)
    label.text = "  *选择您通知的区域，客人到达时，您将会收到通知，且要作出处理"
    label.numberOfLines = 0
    label.textColor = UIColor.ZKJS_themeColor()
    return label
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! InformCell
    cell.changeSelectedButtonImage()
    updateSelectedArrayWithCell(cell)
  }
  
  func tappedCellSelectedButton(sender: UIButton) {
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! InformCell
    updateSelectedArrayWithCell(cell)
  }
  
  func updateSelectedArrayWithCell(cell: InformCell) {
    if cell.isUncheck == false {
      self.selectedArray.append(cell.selectedButton.tag)
    } else {
      if let index = selectedArray.indexOf(cell.selectedButton.tag) {
        selectedArray.removeAtIndex(index)
      }
    }
  }
  
  func nextStep() {
    for index in selectedArray {
      let area = areaArray[index]
      str = area.locid?.stringValue
      areaArr.append(str)
    }
    locID = areaArr.joinWithSeparator(",")
    print("locID: \(locID)")
    ZKJSHTTPSessionManager.sharedInstance().TheClerkModifiestheAreaOfJurisdictionWithLocID(locID, success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      self.updateYunBaTopic()
      AccountManager.sharedInstance().savebeaconLocationIDs(self.locID)
      if self.dismissWhenFinished == true {
        self.dismissViewControllerAnimated(true, completion: nil)
      } else {
        self.navigationController?.popToRootViewControllerAnimated(true)
      }
      }) { (task: NSURLSessionDataTask!, error:NSError!) -> Void in
        
    }
  }
  
  func updateYunBaTopic() {
    print("areaArr: \(areaArr)")
    print("noticeArray: \(noticeArray)")
    for topic in noticeArray {
      if areaArr.contains(topic.stringValue) {
        // 选中则监听区域
        YunBaService.subscribe(topic.stringValue) { (success: Bool, error: NSError!) -> Void in
          if success {
            print("[result] subscribe to topic(\(topic)) succeed")
          } else {
            print("[result] subscribe to topic(\(topic)) failed: \(error), recovery suggestion: \(error.localizedRecoverySuggestion)")
          }
        }
      } else {
        // 没选中则停止监听区域
        YunBaService.unsubscribe(topic.stringValue) { (success: Bool, error: NSError!) -> Void in
          if success {
            print("[result] unsubscribe to topic(\(topic)) succeed")
          } else {
            print("[result] unsubscribe to topic(\(topic)) failed: \(error), recovery suggestion: \(error.localizedRecoverySuggestion)")
          }
        }
      }
    }
  }
  
}
