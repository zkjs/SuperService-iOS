//
//  InvitationRecordVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/7.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit
//import Foundation


class InvitationRecordVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  var code = String()
  var userCodeArray = [CodeModel]()
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    
    super.viewDidLoad()
    loadData()
    self.navigationController!.navigationBar.translucent = true
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController!.navigationBar.shadowImage = UIImage()
    let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: nil)
    let item2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancle:")
    self.navigationItem.rightBarButtonItem = item1
    self.navigationItem.leftBarButtonItem = item2
    let nibName = UINib(nibName: InvitationRecordCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: InvitationRecordCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
  }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("InvitationRecordVC", owner:self, options:nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
  }
  func cancle(sender:UIButton) {
    self.navigationController!.navigationBar.translucent = false
    navigationController?.popViewControllerAnimated(true)
    
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
    let offsetY = scrollView.contentOffset.y
    if (offsetY > 50) {
      let alpha = min(1, 1 - ((50 + 64 - offsetY) / 64))
      //print(alpha)
      self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
      
    } else {
      self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userCodeArray.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return InvitationRecordCell.height()
  }
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 200
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("InvitationRecordCell", forIndexPath:indexPath) as! InvitationRecordCell
     let userCode = userCodeArray[indexPath.row]
    cell.setupData(userCode)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let myView = NSBundle.mainBundle().loadNibNamed("CodeHeaderView", owner: self, options: nil).first as? CodeHeaderView
    self.view.addSubview(myView!)
    return myView
  }
  //Private
  
  func loadData() {
    ZKJSHTTPSessionManager.sharedInstance().whoUsedMyCodeWithCode(code, success: { (task: NSURLSessionDataTask!,responseObject: AnyObject!) -> Void in
      let dic = responseObject as! NSDictionary
      if let array = dic["data"] as? NSArray {
        for dict in array {
          let code = CodeModel(dic: dict as! [String:AnyObject])
          self.userCodeArray.append(code)
        }
        self.tableView.reloadData()
      }
      }) { (task: NSURLSessionDataTask!,error: NSError!) -> Void in
        
    }
  }
  
  
}
