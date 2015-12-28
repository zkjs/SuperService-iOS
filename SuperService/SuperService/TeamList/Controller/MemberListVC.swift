//
//  MemberListVC.swift
//  SuperService
//
//  Created by admin on 15/10/28.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class MemberListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  lazy var memberListArray = [MemberModel]()
  var newDepartment = UITextField()
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Lifecycle
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("MemberListVC", owner:self, options:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "部门列表"
    
    getMemberListData()
    let nibName = UINib(nibName: MemberListCell.nibName(), bundle: nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: MemberListCell.reuseIdentifier())
    tableView.tableFooterView = UIView()
  }
  
  // MARK: - Public
  
  func AddDepartment(sender:UIButton) {
    ZKJSHTTPSessionManager.sharedInstance().addDepartmentWithDepartment(newDepartment.text, success: { (task:NSURLSessionDataTask!, responObject:AnyObject!) -> Void in
      let dic = responObject as! [String: AnyObject]
      if let set = dic["set"] as? Bool {
        if set == true {
          self.addNewdepartment()
        }
      }
      }) { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
        self.showHint("请填写部门信息")
    }
  }
  
  func addNewdepartment() {
    let member = MemberModel()
    member.dept_name = newDepartment.text
    self.memberListArray.append(member)
    self.tableView.reloadData()
  }
  
  func getMemberListData() {
    ZKJSHTTPSessionManager.sharedInstance().getMemberListWithSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? NSArray {
        var datasource = [MemberModel]()
        for dic in array{
          let member = MemberModel(dic: dic as! [String: AnyObject])
          datasource.append(member)
        }
        self.memberListArray = datasource
        self.tableView.reloadData()
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
  // MARK: - Tabel View DataSource
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50.0
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 50
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.memberListArray.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return MemberListCell.height()
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MemberListCell", forIndexPath: indexPath) as!MemberListCell
    let member = memberListArray[indexPath.row]
    cell.textLabel?.text = member.dept_name
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    return cell
  }
  
  //MARK: - Table View Delegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let member = memberListArray[indexPath.row]
    let vc = navigationController?.viewControllers[1] as! AddMemberVC
    vc.departmentLabel.text = member.dept_name
    navigationController?.popToViewController(vc, animated: true)
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerV = NSBundle.mainBundle().loadNibNamed("DepartmentHeaderView", owner: self, options: nil).first as? DepartmentHeaderView
    if headerV != nil {
      self.view.addSubview(headerV!)
    }
    return headerV
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerV = NSBundle.mainBundle().loadNibNamed("DepartmentFooterView", owner: self, options: nil).first as? DepartmentFooterView
    if footerV != nil {
      self.view.addSubview(footerV!)
    }
    return footerV
  }
  
}
