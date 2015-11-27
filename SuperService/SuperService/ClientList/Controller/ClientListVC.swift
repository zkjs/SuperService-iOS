//
//  ClientListVC.swift
//  SuperService
//
//  Created by Hanton on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

typealias ClientSelectionBlock = (ClientModel) -> ()

class ClientListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, refreshTableViewDelegate, XLPagerTabStripChildItem {
  
  @IBOutlet weak var tableView: UITableView!
  
  //根据名字的首字母自动归类 使用UILocalizedIndexedCollation类
  var delegate:refreshTableViewDelegate?
  let collation = UILocalizedIndexedCollation.currentCollation()
  var sections = [[AnyObject]]()
  var clientArray = [ClientModel]() {
    didSet {
      let selector: Selector = "username"
      sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
      
      let sortedObjects = collation.sortedArrayFromArray(clientArray, collationStringSelector: selector)
      for object in sortedObjects {
        let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
        sections[sectionNumber].append(object)
      }
      
      self.tableView.reloadData()
    }
  }
  var selection: ClientSelectionBlock?
  
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("ClientListVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadData()
    delegate = self
    title = "客户"
    let addVC = AddClientVC()
    addVC.delegate = self

    let nibName = UINib(nibName: ClientListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: ClientListCell.reuseIdentifier())
    
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    let isAdmin = AccountManager.sharedInstance().isAdmin()
    if isAdmin == false {
      // 员工才能添加客户
      let addClientButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "AddClientBtn:")
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let baseNC = appDelegate.mainTBC.selectedViewController as! BaseNavigationController
      baseNC.topViewController?.navigationItem.rightBarButtonItem = addClientButton
    }
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    let isAdmin = AccountManager.sharedInstance().isAdmin()
    if isAdmin == false {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let baseNC = appDelegate.mainTBC.selectedViewController as! BaseNavigationController
      baseNC.topViewController?.navigationItem.rightBarButtonItem = nil
    }
  }
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "客户"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor! {
    return UIColor.whiteColor()
  }
  
  
  // MARK: - Button Action
  
  @IBAction func SearchClientBtn(sender: UIButton) {
    
  }
  
  @IBAction func AddClientBtn(sender: UIButton) {
    let addVC = InquiryVC()
    addVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(addVC, animated: true)
  }
  
  
  //MARK - delegate
  
  func refreshTableView(set: [String : AnyObject], clientModel: ClientModel) {
    let client = clientModel
    self.clientArray.append(client)
    self.tableView.reloadData()
  }
  
  func loadData() {
    ZKJSHTTPSessionManager.sharedInstance().getClientListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? NSArray {
        var datasource = [ClientModel]()
        for dic in array{
          let client = ClientModel(dic: dic as! [String: AnyObject])
          datasource.append(client)
        }
        self.tableView.reloadData()
        self.clientArray = datasource
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
    
  }
  
  
  // MARK: - Table View Data Source
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return sections.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return sections[section].count
    
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ClientListCell.height()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ClientListCell", forIndexPath: indexPath) as! ClientListCell
    
    let section = sections[indexPath.section]
    let client = section[indexPath.row] as! ClientModel
    cell.setData(client)
  
    
    return cell
  }
  
  
  // MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if (sections[section].count == 0){
      return nil
    }
    return collation.sectionTitles[section]
  }
  
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    if (sections.count == 0){
      return nil
    }
    
    var titleArray = [String]()
    
    for (var i = 0 ; i < collation.sectionTitles.count; i++) {
      if (sections[i].count != 0){
        titleArray.append(collation.sectionTitles[i])
        
      }
    }
    titleArray.append(collation.sectionTitles[26])
    return titleArray
    
  }
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    return collation.sectionForSectionIndexTitleAtIndex(index)
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let vc = EmployeeVC()
    let section = sections[indexPath.section]
    let client = section[indexPath.row] as! ClientModel
    vc.type = EmployeeVCType.client
    vc.client = client
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
}
