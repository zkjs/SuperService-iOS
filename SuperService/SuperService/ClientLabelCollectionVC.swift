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
class ClientLabelCollectionVC: UICollectionViewController {
  var clientInfo = ArrivateModel()
  var clientTags: TagsModel?


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
      cell.configCell((clientTags?.tags[indexPath.row])!)
      return cell
    }
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let reusableview = ClientHeadView()
    if (kind == UICollectionElementKindSectionHeader) {
      let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: ClientheadID, forIndexPath:NSIndexPath(index: 0)) as! ClientHeadView
      
      let urlString = NSURL(string: kImageURL)
      if let userImage = clientInfo.userimage {
        let url = urlString?.URLByAppendingPathComponent("\(userImage)")
        view.clientImage.sd_setImageWithURL(url, placeholderImage: nil)
        if let sex = clientInfo.sex,let username = clientInfo.username {
          view.tagLabel.text = username + "  "  + "\(sex)"
        }
        
      }
      return view
    }
    return reusableview
  }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

  @IBAction func cellTapped(sender: CircularProgressView) {
    sender.checked = !sender.checked
  }
}
