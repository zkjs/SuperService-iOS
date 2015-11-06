//
//  SettingUpTVC.swift
//  SuperService
//
//  Created by AlexBang on 15/11/6.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class SettingUpTVC: UITableViewController {
  
  @IBOutlet weak var codeLabel: UILabel!
  @IBOutlet weak var telphoneLabel: UILabel!
  @IBOutlet weak var businessInformationLabel: UILabel!
  @IBOutlet weak var mechanismLabel: UILabel!
  @IBOutlet weak var organizationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
      return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
  
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      return cell
    }
  
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let myView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil).first as? HeaderView
      if myView != nil {
        let userID = AccountManager.sharedInstance().userID
        let url = NSURL(string: kBaseURL)
        let urlStr = url?.URLByAppendingPathComponent("uploads/users/\(userID).jpg")
        myView?.userImageView.sd_setImageWithURL(urlStr, placeholderImage: UIImage(named: "img_hotel_zhanwei"))
        myView?.selectedImageViewButton.addTarget(self, action: "selectedIamge:", forControlEvents: UIControlEvents.TouchUpInside)
        myView?.usernameLabel.text = AccountManager.sharedInstance().userName
        self.tableView.addSubview(myView!)
      }
      return myView
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if indexPath == NSIndexPath(forRow: 2, inSection: 0) {
      let vc = InformVC()
      self.navigationController?.pushViewController(vc, animated: true)
    }
    if indexPath == NSIndexPath(forRow: 5, inSection: 0) {
      let vc = CodeVC()
      self.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
      
    }
  }
  
  func selectedIamge(sender:UIButton) {
      let vc = SetUpVC()
    navigationController?.pushViewController(vc, animated: true)
    
    }

}
