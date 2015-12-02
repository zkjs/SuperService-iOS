//
//  CodeVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class CodeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   var page = 1
  lazy var codeArray = [String]()
  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.tableFooterView = UIView()
      
      let nibName = UINib(nibName: CodeCell.nibName(), bundle: nil)
      tableView.registerNib(nibName, forCellReuseIdentifier: CodeCell.reuseIdentifier())
      tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshData")  // 下拉刷新
      tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")  // 上拉加载
      let image = UIImage(named: "ic_tianjia")
      let addCodeButton = UIBarButtonItem(image: image, style:.Plain, target: self, action: "addCode:")
      self.navigationItem.rightBarButtonItem = addCodeButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("CodeVC", owner:self, options:nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.mj_header.beginRefreshing()
  }
  
  func addCode(sender:UIButton) {
    ZKJSHTTPSessionManager.sharedInstance().theWaiterRandomAccessToanInvitationCodeSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      let dic = responseObject as! NSDictionary
      self.codeArray.append(dic["code"] as! String)
      self.tableView.reloadData()
      }) { (task: NSURLSessionDataTask!, erroe: NSError!) -> Void in
        
    }
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return codeArray.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return CodeCell.height()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CodeCell", forIndexPath: indexPath) as! CodeCell
    let string = codeArray[indexPath.row]
    cell.setData(string)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
      return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = InvitationRecordVC()
    vc.code = codeArray[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }

  func loadMoreData() {
    page++
    setupData(page)
    
  }
  func refreshData() {
    page = 1
    codeArray.removeAll()
    setupData(page)
  }
  
  func setupData(page:AnyObject) {
    ZKJSHTTPSessionManager.sharedInstance().theWaiterCheckMyInvitationWithPage(String(page), pageData: "10", success: { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
       let dic = responseObject as! NSDictionary
      if let array = dic["code_data"] as? NSArray {
        for dict in array {
          let code = CodeModel(dic: dict as! [String:AnyObject])
          self.codeArray.append(code.salecode!)
        }
        self.tableView.reloadData()
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
      }
      }) { (task: NSURLSessionDataTask!, erroe: NSError!) -> Void in
        
    }
  }

  
}
