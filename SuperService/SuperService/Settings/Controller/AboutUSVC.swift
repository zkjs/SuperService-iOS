//
//  AboutUSVC.swift
//  SuperService
//
//  Created by AlexBang on 15/12/2.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class AboutUSVC: UIViewController{

  @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
      navigationItem.backBarButtonItem = item;
      
      let url = NSURL(string: "http://www.zkjinshi.com/about_us")
      let req = NSURLRequest(URL: url!)
      webView.loadRequest(req)
    }
  override func loadView() {
    NSBundle.mainBundle().loadNibNamed("AboutUSVC", owner:self, options:nil)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}
