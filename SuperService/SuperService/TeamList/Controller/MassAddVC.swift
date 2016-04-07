//
//  MassAddVC.swift
//  SuperService
//
//  Created by AlexBang on 16/3/9.
//  Copyright © 2016年 ZKJS. All rights reserved.
//

import UIKit

class MassAddVC: UIViewController {
  var ContactsArray = [[String:String]]()
  var phoneArray = [String]()
  var usernameArray = [String]()
  var massPhoneArray = [String]()//批量选择联系人的手机号
  var massusernameArray = [String]()//批量选择联系人的名字
  var massDicArray = [[String:String]]()//批量选择联系人的手机和名字的数组集合
  var dic = [String:String]()
  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "批量添加联系人"
      navigationController?.navigationBarHidden = false
      let nibName = UINib(nibName: MassCell.nibName(), bundle: nil)
      tableView.registerNib(nibName, forCellReuseIdentifier: MassCell.reuseIdentifier())
      tableView.tableFooterView = UIView()
      let nextStepButton = UIBarButtonItem(image: UIImage(named: "ic_qianjin"), style: UIBarButtonItemStyle.Plain ,
        target: self, action: "nextStep")
      navigationItem.rightBarButtonItem = nextStepButton

        // Do any additional setup after loading the view.
    }
  
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("MassAddVC", owner:self, options:nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    for dic in ContactsArray {
      if let phone = dic["phone"],let username = dic["username"] {
        self.phoneArray.append(phone)
        self.usernameArray.append(username)
      }
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //MARK: - Table View Data Source
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return phoneArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MassCell", forIndexPath: indexPath) as! MassCell
    let phone = phoneArray[indexPath.row]
    let username = usernameArray[indexPath.row]
    cell.locationLabel.text = username
    cell.phoneLabel.text = phone
    cell.selectedButton.addTarget(self, action: "tappedCellSelectedButton:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.selectedButton.tag = indexPath.row
    if massusernameArray.contains(username) {
      cell.isUncheck = false
      cell.selectedButton.setImage(UIImage(named: "ic_jia_pre"), forState:UIControlState.Normal)
    } else {
      cell.isUncheck = true
      cell.selectedButton.setImage(UIImage(named: "ic_jia_nor"), forState:UIControlState.Normal)
    }

    
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
    label.frame = CGRectMake(30, 108, 280, 40)
    label.text = "  *选择您需要批量添加的员工"
    label.numberOfLines = 0
    label.textColor = UIColor.ZKJS_themeColor()
    return label
   
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! MassCell
    cell.changeSelectedButtonImage()
    updateSelectedArrayWithCell(cell)
  }
  
  func tappedCellSelectedButton(sender: UIButton) {
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! MassCell
    updateSelectedArrayWithCell(cell)
  }
  
  func updateSelectedArrayWithCell(cell: MassCell) {
   let phone = phoneArray[cell.selectedButton.tag]
    let username = usernameArray[cell.selectedButton.tag]
    if cell.isUncheck == true {
      if massusernameArray.contains(username) {
        if let idx = massusernameArray.indexOf(username) {
          massPhoneArray.removeAtIndex(idx)
          massusernameArray.removeAtIndex(idx)
        }
      }
    } else {
      if massusernameArray.contains(username)  {
        return
      } else {
      self.massPhoneArray.append(phone)
      self.massusernameArray.append(username)
      }
    }
    print(massPhoneArray,massusernameArray)

  }
  
   func nextStep() {
    if massDicArray.count != 0 {
      massDicArray.removeAll()
    }
    for phone in massPhoneArray {
      if let idx = massPhoneArray.indexOf(phone) {
        let username = massusernameArray[idx]
       dic = ["phone":phone,"username":username]
             }
       massDicArray.append(dic)
    }
    let dict = ["users":massDicArray]
    HttpService.sharedInstance.AddMember(dict) { (json, error) -> () in
      if let _ = error {
        self.showHint("添加失败")
      } else {
        if let json = json {
          if let res = json["res"].int {
            if res == 0 {
                self.showHint("添加成功")
              self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
              self.showHint("\(json["resDesc"].string)")
            }
          }
        }
      }
    }
  }


}
