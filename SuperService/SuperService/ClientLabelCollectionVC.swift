//
//  ClientLabelCollectionVC.swift
//  SuperService
//
//  Created by AlexBang on 16/4/28.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ClientLabelCollectionCell"
private let ClientheadID = "ClientHeadView"
private let ClientFootID = "ClientFooterView"
class ClientLabelCollectionVC: UICollectionViewController {
  var clientInfo = ArrivateModel()
  var clientTags: TagsModel?
  var tagidArr = [Int]()
  var toolBar:UIToolbar!


  override func viewDidLoad() {
      super.viewDidLoad()

      // Register cell classes
    let width = DeviceType.IS_IPAD ? 200 : 100
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: width)
    layout.headerReferenceSize = CGSizeMake(0, DeviceType.IS_IPAD ? 270 : 170)
    
    title = "客户信息"
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    setupView()
    loadData()
  }
  
  func setupView() {
    toolBar = UIToolbar(frame: CGRectMake(0,UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 50))
    UIView.animateWithDuration(1, animations: { () -> Void in
          self.toolBar.frame =  CGRectMake(0,UIScreen.mainScreen().bounds.size.height - 114, UIScreen.mainScreen().bounds.size.width, 50)
      }) { (bool) -> Void in
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FlexibleSpace, target:"barButtonItemClicked:", action:nil)
        self.toolBar.tintColor = UIColor.whiteColor()
        self.toolBar.translucent = true
        let backItem = UIBarButtonItem(title: "确认", style:UIBarButtonItemStyle.Plain, target:self, action:#selector(ClientLabelCollectionVC.sure(_:)))
        self.toolBar.barTintColor = UIColor(hex:"#03A9F4")
        self.toolBar.items = [flexibleSpace,backItem,flexibleSpace]
        self.view.addSubview(self.toolBar)
        self.toolBar.hidden = true

    }
    
  }
  
  func addToolbar() {
    if tagidArr.count >= 1 {
      self.toolBar.hidden = false
    } 
    if tagidArr.count == 0 {
      self.toolBar.hidden = true
    }
  }
  
  func loadData() {
    showHUDInView(view, withLoading: "")
    guard let userid = clientInfo.userid else {return}
    HttpService.sharedInstance.queryUsertags(userid) { (json, error) -> Void in
      if let error = error {
        print(error)
        self.hideHUD()
      } else {
        if let users = json{
          self.clientTags = users
          self.collectionView?.reloadData()
          self.hideHUD()
        }
      }
    }
  }


    // MARK: UICollectionViewDataSource

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }


  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of items
      return clientTags?.tags.count ?? 0
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClientLabelCollectionCell
    if let tag = clientTags?.tags[indexPath.row] {
      cell.circulView.tag = indexPath.row
      cell.configCell(tag)
      if tagidArr.contains(tag.tagid) {
        cell.circulView.checked = true
      } else {
        cell.circulView.checked = false
      }
      cell.circulView.percent = CGFloat(tag.count)/100.0
    }
    return cell
  }
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let reusableview = ClientHeadView()
    if (kind == UICollectionElementKindSectionHeader) {
      let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: ClientheadID, forIndexPath:NSIndexPath(index: 0)) as! ClientHeadView
      headView.setupView(clientInfo)
      return headView
    } 

    return reusableview
  }
  
  

  @IBAction func cellTapped(sender: CircularProgressView) {
    guard let canoptcnt = clientTags?.canoptcnt where canoptcnt != 0 else {
      self.showHint("一天只可添加3次", withFontSize: 18)
      return
    }
    sender.checked = !sender.checked
    let tag = clientTags?.tags[sender.tag]
    if sender.checked == true,let isopt = tag?.isopt {//添加标签
      if isopt == 1 {
        self.showHint("您已标注过，请不要重复设置", withFontSize: 18)
        sender.checked = false
      } else {
        if tagidArr.count < canoptcnt {
          tagidArr.append((tag?.tagid)!)
        } else {
          self.showHint("一次只可添加3个标签", withFontSize: 18)
          sender.checked = false
        }
        addToolbar()
      }
    } else {//取消标签
      for (index, value) in tagidArr.enumerate() {
        if case (tag?.tagid)! = value {
          tagidArr.removeAtIndex(index)
        }
       addToolbar() 
      }
      
    }
    
  }
  
  
  func sure(sender:UIBarButtonItem) {
    HttpService.sharedInstance.updataUsertags(clientInfo.userid!, tags: tagidArr) { (json, error) -> Void in
      if let error = error {
        self.showErrorHint(error)
      } else {
        for (index, value) in (self.clientTags?.tags.enumerate())! {
          if self.tagidArr.contains(value.tagid) {
            self.clientTags?.tags[index].count += 1
            self.clientTags?.tags[index].isopt = 1
          }
        }
        self.collectionView?.reloadData()
        self.tagidArr.removeAll()
        self.showHint("更改成功", withFontSize: 24)
        self.addToolbar()
      }
    }
  }
}
