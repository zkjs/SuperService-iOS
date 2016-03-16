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
  var noticeArray = [String]()
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
    let nextStepButton = UIBarButtonItem(image: UIImage(named: "ic_qianjin"), style: UIBarButtonItemStyle.Plain ,
      target: self, action: "nextStep")
    navigationItem.rightBarButtonItem = nextStepButton
  }
  
  override func viewWillAppear(animated: Bool) {
    GetWholeAreaOfTheList()
  }
  
  func GetWholeAreaOfTheList() {
    if let arr = StorageManager.sharedInstance().noticeArray() {
       self.noticeArray = arr
    }
    HttpService.getSubscribeList { (json, error) -> Void in
      if let _ = error {
        
      } else {
        if let jsonArr = json!["data"].array {
          for dict in jsonArr {
            let area = AreaModel(dic: dict)
            self.areaArray.append(area)
            if  dict["subscribed"] == 1 {
               self.noticeArray.append(area.locid!)
            }
          }
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
          print("Found \(value) at position \(index)")
          if case area.locid! = value {
            noticeArray.removeAtIndex(index)
          }
        }
      }
    }
    StorageManager.sharedInstance().saveLocids(noticeArray)
  }
  
  func nextStep() {
    for index in selectedArray {
      let area = areaArray[index]
      str = area.locid
      areaArr.append(str)
    }
    locID = areaArr.joinWithSeparator(",")
    print("locID: \(locID)")
    AccountInfoManager.sharedInstance.savebeaconLocationIDs(self.locID)
    let vc = self.navigationController?.viewControllers[0] as! SettingsVC
    let appWindow = UIApplication.sharedApplication().keyWindow
    let mainTBC = MainTBC()
    mainTBC.selectedIndex = 0
    appWindow?.rootViewController = mainTBC
    self.navigationController?.popToViewController(vc, animated: false)
    
//    self.navigationController?.popToRootViewControllerAnimated(false)
  
  }
  
}
