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


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
      let width = 100
      let layout = collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSize(width: width, height: width)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    loadData()
  }
  
  func loadData() {
    guard let userid = clientInfo.userid else {return}
    HttpService.sharedInstance.queryUsertags(userid) { (json, error) -> Void in
      if let error = error {
        print(error)
      } else {
        if let users = json{
          self.clientTags = users
          self.collectionView?.reloadData()
        }
      }
    }
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
        cell.circulView.percent = CGFloat(tag.count/100)
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
    if (kind == UICollectionElementKindSectionFooter) {
      let footView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: ClientFootID, forIndexPath:NSIndexPath(index: 0)) as! ClientFooterView
      footView.sureButton.addTarget(self, action: "sure:", forControlEvents: .TouchUpInside)
      return footView
      
    }
    return reusableview
  }
  
  

  @IBAction func cellTapped(sender: CircularProgressView) {
    sender.checked = !sender.checked
    guard let canoptcnt = clientTags?.canoptcnt where canoptcnt != 0 else {
      self.showHint("一天只可添加3次", withFontSize: 18)
      return
    }
    let tag = clientTags?.tags[sender.tag]
    if sender.checked == true,let isopt = tag?.isopt {//添加标签
      if isopt == 1 {
        self.showHint("您已标注过，请不要重复设置", withFontSize: 18)
        sender.checked = false
      } else {
        if tagidArr.count < 3 {
          tagidArr.append((tag?.tagid)!)
        }else {
          self.showHint("一次只可添加3个标签", withFontSize: 18)
          sender.checked = false
        }
        print(tagidArr)
      }
    } else {//取消标签
      for (index, value) in tagidArr.enumerate() {
        if tagidArr.count == 1 {
          tagidArr.removeAtIndex(0)
          return
        }
        if case (tag?.tagid)! = value {
          tagidArr.removeAtIndex(index)
          print(tagidArr)
          print("Found \(value) at position \(index)")
          
        }
        
      }
    }
  }
  
  
  func sure(sender:UIButton) {
    HttpService.sharedInstance.updataUsertags(clientInfo.userid!, tags: tagidArr) { (json, error) -> Void in
      if let _ = error {
        
      } else {
        self.showHint("更改成功", withFontSize: 24)
        self.navigationController?.popToRootViewControllerAnimated(true)
      }
    }
  }
}
