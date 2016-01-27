//
//  ClientListVC.swift
//  SuperService
//
//  Created by Hanton on 10/9/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//

import UIKit

@objc enum ClientListVCType: Int {
  case order
  case detail
}

typealias ClientSelectionBlock = (ClientModel) -> ()

class ClientListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, XLPagerTabStripChildItem {
  
  // 根据名字的首字母自动归类 使用UILocalizedIndexedCollation类
  let collation = UILocalizedIndexedCollation.currentCollation()
  
  @IBOutlet weak var tableView: UITableView!
  
  var type = ClientListVCType.detail
  var emptyLabel = UILabel()
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
    
    title = "客户"
    let nibName = UINib(nibName: ClientListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: ClientListCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
    emptyLabel.frame = CGRectMake(0.0, 0.0, 150.0, 30.0)
    let screenSize = UIScreen.mainScreen().bounds
    emptyLabel.textAlignment = .Center
    emptyLabel.font = UIFont.systemFontOfSize(14)
    emptyLabel.text = "暂无客户"
    emptyLabel.textColor = UIColor.lightGrayColor()
    emptyLabel.center = CGPointMake(screenSize.midX, screenSize.midY - 60.0)
    emptyLabel.hidden = true
    view.addSubview(emptyLabel)
    
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadData")  // 下拉刷新
    tableView.mj_header.beginRefreshing()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    clientArray.removeAll()
    loadData()
  }
  
  // MARK: - XLPagerTabStripChildItem Delegate
  
  func titleForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> String! {
    return "客户"
  }
  
  func colorForPagerTabStripViewController(pagerTabStripViewController: XLPagerTabStripViewController!) -> UIColor{
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
    ZKJSHTTPSessionManager.sharedInstance().getClientListWithPage("1", success:{ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      let dic = responseObject as! NSDictionary
      self.tableView.mj_header.endRefreshing()
      let headDic = dic["head"] as! NSDictionary
      if let set = headDic["set"] as? NSNumber {
        if set.boolValue == false {
          self.emptyLabel.hidden = false
        } else {
          self.emptyLabel.hidden = true
        }
      }
      if let array = dic["data"] as? NSArray {
          var datasource = [ClientModel]()
          for dic1 in array{
            let client = ClientModel(dic: dic1 as! [String: AnyObject])
            datasource.append(client)
          }
          self.tableView.reloadData()
          self.clientArray = datasource
      }
      self.tableView.mj_header.endRefreshing()
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        self.tableView.mj_header.endRefreshing()
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
    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("avatarTapped:"))
    cell.userImage.addGestureRecognizer(tapGestureRecognizer)
    cell.userImage.tag = indexPath.section*1000 + indexPath.row
    cell.userImage.userInteractionEnabled = true
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
  
  func avatarTapped(sender: UIGestureRecognizer) {
    guard let tag = sender.view?.tag else { return }
    let indexSection = tag/1000
    let indexRow = tag - indexSection*1000
    let vc = EmployeeVC()
    let section = sections[indexSection]
    let client = section[indexRow] as! ClientModel
    vc.type = EmployeeVCType.client
    vc.client = client
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if type == ClientListVCType.detail {
      let section = sections[indexPath.section]
      let client = section[indexPath.row] as! ClientModel
      var chatterName = ""
      guard let chatterID = client.userid else { return }
      if let name = client.username {
        chatterName = name
      }
      let vc = ChatViewController(conversationChatter: chatterID, conversationType: .eConversationTypeChat)
      let userName = AccountManager.sharedInstance().userName
      vc.title = chatterName
      vc.hidesBottomBarWhenPushed = true
      // 扩展字段
      let ext = ["toName": chatterName,
        "fromName": userName]
      vc.conversation.ext = ext
      navigationController?.pushViewController(vc, animated: true)
    } else {
      let client = clientArray[indexPath.row]
      if (selection != nil){
        selection!(client)
        self.navigationController?.popViewControllerAnimated(true)
      }
    }
  }
  
}
