//
//  InformVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
enum ApperType {
  case push
  case presents
}
class InformVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
  
  @IBOutlet weak var tableView: UITableView!
  var dic:NSDictionary!
  var noticeArray = [String]()
  var str:String!
  var areaArray = [AreaModel]()
  var locID = (String)()
  var nearlistLocids = [String]()//收银台的locid数组
  var selectedArray = [Int]()
  var areaArr = [String]()
  var dismissWhenFinished = false
  var type = ApperType?()
  var topicsArray = [String]()//云巴订阅的数组
  
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
    let nextStepButton = UIBarButtonItem(image: UIImage(named: "ic_qianjin"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: "nextStep")
    navigationItem.rightBarButtonItem = nextStepButton
  }
  
  override func viewWillAppear(animated: Bool) {
    GetWholeAreaOfTheList()
  }
  
  func GetWholeAreaOfTheList() {
    self.noticeArray.removeAll()
    if let arr = StorageManager.sharedInstance().noticeArray() {
       self.noticeArray = arr
    }
    HttpService.sharedInstance.getSubscribeList { (json, error) -> Void in
      if let _ = error {
        
      } else {
        if let jsonArr = json!["data"].array {
          self.areaArray.removeAll()
          for dict in jsonArr {
            let area = AreaModel(dic: dict)
            if area.payment_support == 0 {//暂时过滤掉具有收款台功能的区域
              self.areaArray.append(area)
            }
            if area.payment_support == 1,let str = area.locid {
              self.nearlistLocids.append(str)//收银台数组
            }
        }
          StorageManager.sharedInstance().saveBeaconPayLocids(self.nearlistLocids)
          self.initSelectedArray()  // Model
          self.tableView.reloadData()  // UI
        }
      }
    }
  }
  
  func initSelectedArray() {
    for index in 0..<areaArray.count {
      if noticeArray.contains(areaArray[index].locid!) {
        selectedArray.append(index)
      }
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
    } else {
      cell.isUncheck = true
      cell.selectedButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
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
    let area = areaArray[cell.selectedButton.tag]
    
    if cell.isUncheck == false {
      self.selectedArray.append(cell.selectedButton.tag)
      noticeArray.append(area.locid!)
     

    } else {
      if let index = selectedArray.indexOf(cell.selectedButton.tag) {
        selectedArray.removeAtIndex(index)
        for (index, value) in noticeArray.enumerate() {
          if noticeArray.count == 1 {
            noticeArray.removeAtIndex(0)
            return
          }
          if case area.locid! = value {
            noticeArray.removeAtIndex(index)
            print(noticeArray)
            print("Found \(value) at position \(index)")

          }
         
        }
      }
    }
  
    
  }
  
  func nextStep() {
    for index in selectedArray {
      let area = areaArray[index]
      str = area.locid
      
      areaArr.append(str)
    }
    guard let shopid = TokenPayload.sharedInstance.shopid else {return} 
    StorageManager.sharedInstance().saveLocids(areaArr)
    

    print(areaArr)
    var subscribeTopics = [String]()
    for locid in areaArr {//订阅新选择的区域
      if let topic:String = "\(shopid)_BLE_\(locid)" {
        subscribeTopics.append(topic)
        YunBaService.subscribe(topic, resultBlock: { (succ, error) -> Void in
          if succ {
            print("\(shopid)_BLE_\(self.str)")
          } else {
            print(error)
          }
        })
      }
    }
    
    YunBaService.getTopicList { (topics, error) -> Void in
      var canceledTopics = [String]()
      if let topics = topics as? [String] {
        canceledTopics = topics.filter { (t) -> Bool in 
          let roles = TokenPayload.sharedInstance.roles ?? []
          return !subscribeTopics.contains(t) && 
            !roles.map{ TokenPayload.sharedInstance.shopid! + "_" + $0 }.contains(t)
        }  
      }
      
      if canceledTopics.count > 0 {
        for topic in canceledTopics {
          YunBaService.unsubscribe(topic, resultBlock: { (succ, error) -> Void in
            print(succ)
          })
        }
      }
    }
    
    locID = areaArr.joinWithSeparator(",")
    AccountInfoManager.sharedInstance.savebeaconLocationIDs(self.locID)
    if type == .presents {
      self.dismissViewControllerAnimated(true, completion: { () -> Void in
        StorageManager.sharedInstance().savePresentInfoVC(false)
      })
    } else {
    let vc = self.navigationController?.viewControllers[0] as! SettingsVC
    let appWindow = UIApplication.sharedApplication().keyWindow
    let mainTBC = MainTBC()
    mainTBC.selectedIndex = 0
    appWindow?.rootViewController = mainTBC
    self.navigationController?.popToViewController(vc, animated: false)
    }
  }
  
}
