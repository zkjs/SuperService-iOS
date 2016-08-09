//
//  ClientInfoTVC.swift
//  SuperService
//
//  Created by Qin Yejun on 8/8/16.
//  Copyright © 2016 ZKJS. All rights reserved.
//

import UIKit

class ClientInfoTVC: UITableViewController {
  var clientInfo = ArrivateModel()

  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var indicatorView: UIView!
  @IBOutlet weak var habitButton: UIButton!
  @IBOutlet weak var arrivalButton: UIButton!
  @IBOutlet weak var paymentButton: UIButton!
  @IBOutlet weak var indicatorPosConstraint: NSLayoutConstraint!
  
  enum Tabs:Int {
    case Habit = 1, Arrival, Payment
  }
  
  private var currentTab = Tabs.Habit
  var clientTags: TagsModel?
  var arrivalList = [ClientArrivalModel]()
  var paymentList = [ClientPaymentModel]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "客户信息"
    setupView()
    loadData()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  private func setupView(){
    setRightBarButton()
    tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))  // 下拉刷新
    
    if let url = NSURL(string: clientInfo.avatarURL) {
      avatarView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_logo"))
    }
    nameLabel.text = clientInfo.username
    genderLabel.text = clientInfo.displayGender
  }
  
  
  @IBAction func tabButtonTapped(sender: UIButton) {
    var leading = CGFloat(0)
    switch sender.tag {
    case Tabs.Habit.rawValue:// 喜好标签
      leading = 0
    case Tabs.Arrival.rawValue:// 到店记录
      leading = ScreenSize.SCREEN_WIDTH / 3
    case Tabs.Payment.rawValue:// 消费记录
      leading = 2 * ScreenSize.SCREEN_WIDTH / 3
    default:
      break;
    }
    indicatorPosConstraint.constant = leading
    let selectedTab = Tabs(rawValue: sender.tag) ?? .Habit
    if selectedTab != currentTab {
      currentTab = selectedTab
      loadData()
    }
    setRightBarButton()
  }
  
  func loadData() {
    switch currentTab {
    case .Habit:
      loadHabits()
    case .Arrival:
      loadArriving()
    case .Payment:
      loadPayment()
    }
  }
  
  func loadHabits() {
    showHUDInView(view, withLoading: "")
    guard let userid = clientInfo.userid else {return}
    HttpService.sharedInstance.queryUsertags(userid) { (json, error) -> Void in
      self.hideHUD()
      self.tableView.mj_header.endRefreshing()
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json{
          self.clientTags = data
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func loadArriving() {
    guard let userid = clientInfo.userid else { return }
    showHUDInView(view, withLoading: "")
    HttpService.sharedInstance.clientArrivalList(userid) { (json, error) -> Void in
      self.hideHUD()
      self.tableView.mj_header.endRefreshing()
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json{
          self.arrivalList = data
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func loadPayment() {
    guard let userid = clientInfo.userid else { return }
    showHUDInView(view, withLoading: "")
    HttpService.sharedInstance.clientPaymentList(userid) { (json, error) -> Void in
      self.hideHUD()
      self.tableView.mj_header.endRefreshing()
      if let error = error {
        self.showErrorHint(error)
      } else {
        if let data = json{
          self.paymentList = data
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func setRightBarButton() {
    if currentTab == .Habit {
      let addButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(addHabit))
      navigationItem.rightBarButtonItem = addButton
    } else if currentTab == .Payment {
      let addButton = UIBarButtonItem(image: UIImage(named: "ic_tianjia"), style: UIBarButtonItemStyle.Plain ,target: self, action: #selector(addPayment))
      navigationItem.rightBarButtonItem = addButton
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  func addHabit() {
    let alertController = UIAlertController(title: "添加喜爱标签", message: "", preferredStyle:.Alert )
    let checkAction = UIAlertAction(title: "确定", style: .Default) { (_) in
      let tagsTextField = alertController.textFields![0] as UITextField
      guard let tag = tagsTextField.text else {
        self.showHint("请输入标签")
        return
      }
      if tag.length > 8 {
        self.showHint("标签长度超过8个字")
        return
      }
      HttpService.sharedInstance.addTags(tag, completionHandler: { [weak self](json, error) in
        guard let strongSelf = self else {return}
        if let error = error {
          strongSelf.showErrorHint(error)
        } else {
          if let json = json where json["res"].int == 0 {
              strongSelf.loadData()
          } else {
            strongSelf.showErrorHint(error)
          }
        }
      })
      
    }
    checkAction.enabled = false
    let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (_) in
      self.view.endEditing(true)
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) in
      textField.placeholder = "请输入标签(字数不超过8个字)"
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
        checkAction.enabled = (textField.text != "")
      }
    }
    alertController.addAction(checkAction)
    alertController.addAction(cancelAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func addPayment() {
    self.performSegueWithIdentifier("SeguePaymentAdd", sender: nil)
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch currentTab {
    case .Habit:
      return clientTags?.tags.count ?? 0
    case .Arrival:
      return arrivalList.count
    case .Payment:
      return paymentList.count
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if currentTab == .Habit {
      let cell = tableView.dequeueReusableCellWithIdentifier("HabitCell", forIndexPath: indexPath)
      
      let circulView = cell.viewWithTag(1) as! CircularProgressView
      let tagLabel = cell.viewWithTag(2) as! UILabel
      if let tag = clientTags?.tags[indexPath.row] {
        circulView.percent = CGFloat(tag.count)/100.0
        tagLabel.text = tag.tagname
      }
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(currentTab == .Arrival ? "RecordCell" : "PaymentCell", forIndexPath: indexPath)
      let label1 = cell.viewWithTag(1) as! UILabel
      let label2 = cell.viewWithTag(2) as! UILabel
      let label3 = cell.viewWithTag(3) as! UILabel
      label1.text = ""
      label2.text = ""
      label3.text = ""
      if currentTab == .Arrival {
        if arrivalList.count > indexPath.row {
          let item = arrivalList[indexPath.row]
          label1.text = item.firstDate
          label2.text = ""
          label3.text = item.firstTime
        }
      } else if currentTab == .Payment {
        if paymentList.count > indexPath.row {
          let item = paymentList[indexPath.row]
          label1.text = item.createtime
          label2.text = item.displayAmount
          label3.text = item.remark
        }
      }

      return cell
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if currentTab == .Habit {
      performSegueWithIdentifier("SegueHabit", sender: nil)
    }
  }
  
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SeguePaymentAdd" {
      let vc = segue.destinationViewController as! ClientPaymentAdd
      vc.clientInfo = clientInfo
      vc.delegate = self
    } else if segue.identifier == "SegueHabit" {
      let vc = segue.destinationViewController as! ClientHabitTVC
      vc.clientInfo = clientInfo
      vc.delegate = self
    }
  }
}

extension ClientInfoTVC: ClientPaymentAddDelegate {
  func addSuccess() {
    showHint("消费记录添加成功")
    self.loadData()
  }
}

extension ClientInfoTVC: ClientHabitDelegate {
  func tagSuccess() {
    self.loadData()
  }
}
