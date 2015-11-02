//
//  InformVC.swift
//  SuperService
//
//  Created by admin on 15/10/24.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class InformVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

  @IBOutlet weak var tableView: UITableView!
  var areaArray = [AreaModel]()
  var selectedArray = [NSInteger]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "选择通知区域"
      navigationController?.navigationBarHidden = false
      let nibName = UINib(nibName: InformCell.nibName(), bundle: nil)
      tableView.registerNib(nibName, forCellReuseIdentifier: InformCell.reuseIdentifier())
      tableView.tableFooterView = UIView()
      GetWholeAreaOfTheBusinessList()

    }

  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  
  func GetWholeAreaOfTheBusinessList() {
    ZKJSHTTPSessionManager.sharedInstance().WaiterGetWholeAreaOfTheBusinessListSuccess({ (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
      if let array = responseObject as? NSArray {
        var datasource = [AreaModel]()
        for dic in array {
          let area = AreaModel(dic: dic as! [String: AnyObject])
          datasource.append(area)
        }
      self.areaArray = datasource
        print(self.areaArray.count)
        self.tableView.reloadData()
      }
      }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
        
    }
  }
  
    //MARK: - Table View Data Source
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return areaArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("InformCell", forIndexPath: indexPath) as! InformCell
    
    cell.selectedButton.addTarget(self, action: "tappedCellSelectedButton:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.selectedButton.tag = indexPath.row
    return cell
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return InformCell.height()
  }
  
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "选择您通知的区域，客人到达时，您将会收到通知，且要作出处理"
    label.numberOfLines = 0
    
    label.frame = CGRectMake(24, 108, 280, 40)
    return label
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! InformCell
    updateSelectedArrayWithCell(cell)
    cell.changeSelectedButtonImage()
    
    
  }
  
  func tappedCellSelectedButton(sender: UIButton) {
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! InformCell
    updateSelectedArrayWithCell(cell)
  }
  
  func updateSelectedArrayWithCell(cell: InformCell) {
    if cell.isUncheck == false {
      // add to an array
      print("111")
    }
  }
  
  
  

}
