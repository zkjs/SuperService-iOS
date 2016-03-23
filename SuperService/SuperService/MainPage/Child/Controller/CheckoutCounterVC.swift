//
//  CheckoutCounterVC.swift
//  SuperService
//
//  Created by Qin Yejun on 3/9/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CustomerHeaderCell"
private let headID = "PayheadReusableView"
class CheckoutCounterVC: UICollectionViewController {
  

  @IBOutlet weak var search: UICollectionReusableView!

    var nearbyCustomers = [NearbyCustomer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
      self.title = "收款台"
      addBarButtons()
      
      let width = CGRectGetWidth(collectionView!.frame) / 2
      let layout = collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSize(width: width, height: width + 40)
    
      loadData()
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    YunBaService.getAlias { (json, error) -> Void in
      print("订阅的云巴\(json)")
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func loadData() {
    showHUDInView(view, withLoading: "")
    //TODO: shopid，locids均为测试ID，实际需要从api获
    HttpService.getNearbyCustomers(shopid:"9002", locids: "1000") {[weak self] (users, error) -> () in
      guard let strongSelf = self else { return }
      if let error = error {
        if let msg = error.userInfo["resDesc"] as? String {
          strongSelf.showHint(msg)
        } else {
          strongSelf.showHint("数据请求错误:\(error.code)")
        }
      }
      if let users = users where users.count > 0 {
        strongSelf.nearbyCustomers = users
        strongSelf.collectionView?.reloadData()
      } else {
        strongSelf.showHint("未找到用户,您可以通过手机号进行用户查找")
      }
      strongSelf.hideHUD()
    }
  }
  
  private func addBarButtons() {
    let btn = UIBarButtonItem(image: UIImage(named: "bullet_list"),
      style: .Plain,
      target: self,
      action: "gotoPaymentList")
    navigationItem.rightBarButtonItem = btn
  }
  
  func gotoPaymentList() {
    self.performSegueWithIdentifier("PaymentListSegue", sender: nil)
  }
  
  


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyCustomers.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CustomerHeaderCell
  
      // Configure the cell
      
      cell.configCell(nearbyCustomers[indexPath.row])
      
      return cell
    }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("ChargeSegue", sender: indexPath)
  }
  
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let reusableview = PayheadReusableView()
    if (kind == UICollectionElementKindSectionHeader) {
      let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: headID, forIndexPath:NSIndexPath(index: 0)) as! PayheadReusableView
        view.customClosure = { [unowned self](phone) ->Void in
        self.searchByphonenumber(phone)
      }
      return view
    }
      return reusableview
  }
  
  func searchByphonenumber(phone:String) {
    HttpService.searchUserByPhone(phone) { (json, error) -> Void in
      if  let error = error {
        if let msg = error.userInfo["resDesc"] as? String {
          self.showHint(msg)
        } else {
          self.showHint("数据请求错误:\(error.code)")
        }
      } else {
        self.nearbyCustomers.removeAll()
        if let data = json?["data"].array where data.count > 0 {
          for userData in data {
            let user = NearbyCustomer(data: userData)
            if userData["userid"].string == nil ||  userData["userid"].string == "" {
              continue
            }
            self.nearbyCustomers.append(user)
          }
          self.collectionView?.reloadData()
        } else {
          self.showHint("未找到用户")
        }
      }
    }
  }
  

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ChargeSegue" {
      if let vc = segue.destinationViewController as? ChargeVC,
        let indexPath = sender as? NSIndexPath {
          vc.customer = nearbyCustomers[indexPath.row]
      }
    }
  }

}
