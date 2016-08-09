//
//  ClientHabitTVC.swift
//  SuperService
//
//  Created by Qin Yejun on 8/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

protocol ClientHabitDelegate {
  func tagSuccess()
}

class ClientHabitTVC: UITableViewController {
  var clientInfo = ArrivateModel()
  var delegate: ClientHabitDelegate?
  
  var clientTags: TagsModel?
  var selectedIndex = [Int]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "喜好标签"
    setupView()
    loadData()
  }
  
  private func setupView(){
    setRightBarButton()
  }
  
  func loadData() {
    loadHabits()
  }
  
  func loadHabits() {
    showHUDInView(view, withLoading: "")
    guard let userid = clientInfo.userid else {return}
    HttpService.sharedInstance.queryUsertags(userid) { (json, error) -> Void in
      self.hideHUD()
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json{
          self.clientTags = data
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func setRightBarButton() {
    let addButton = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: #selector(confirm))
    self.navigationItem.rightBarButtonItem = addButton
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return clientTags?.tags.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("HabitCell", forIndexPath: indexPath)
    
    let circulView = cell.viewWithTag(1) as! CircularProgressView
    let tagLabel = cell.viewWithTag(2) as! UILabel
    let checkButton = cell.viewWithTag(3) as! UIButton
    if let tag = clientTags?.tags[indexPath.row] {
      circulView.percent = CGFloat(tag.count)/100.0
      tagLabel.text = tag.tagname
      
      if tag.isopt == 1 {
        checkButton.enabled = false
        checkButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
      } else {
        checkButton.enabled = true
        
        if selectedIndex.contains(indexPath.row) {
          checkButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
        } else {
          checkButton.setImage(UIImage(named: "ic_-round_blue"), forState:UIControlState.Normal)
        }
      }
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    guard let tag = clientTags?.tags[indexPath.row] else { return }
    if tag.isopt == 1 { return }
    
    if selectedIndex.contains(indexPath.row) {//remove
      if let idx = selectedIndex.indexOf(indexPath.row) {
        selectedIndex.removeAtIndex(idx)
      }
    } else {// add
      let maxCnt = clientTags?.canoptcnt ?? 0
      if selectedIndex.count >= maxCnt {
        showHint("超过当天打标签上限")
        return
      }
      selectedIndex.append(indexPath.row)
    }
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }
  
  func confirm() {
    if (selectedIndex.count < 1) {
      showHint("请选择至少一个标签")
      return
    }
    guard let tags = clientTags?.tags else { return }
    let tagidArr = selectedIndex.map { tags[$0].tagid }
    navigationItem.rightBarButtonItem?.enabled = false
    HttpService.sharedInstance.updataUsertags(clientInfo.userid!, tags: tagidArr) { (json, error) -> Void in
      self.navigationItem.rightBarButtonItem?.enabled = true
      if let error = error {
        self.showErrorHint(error)
      } else {
        self.selectedIndex.removeAll()
        self.showHint("打标签成功", withFontSize: 24)
        self.navigationController?.popViewControllerAnimated(true)
        self.delegate?.tagSuccess()
      }
    }
  }
  
}
