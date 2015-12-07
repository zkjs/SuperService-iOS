//
//  ZKJSGuideVC.swift
//  SuperService
//
//  Created by AlexBang on 15/12/3.
//  Copyright © 2015年 ZKJS. All rights reserved.
//

import UIKit

class ZKJSGuideVC: IFTTTAnimatedPagingScrollViewController{
  
  var numOfPages = 4
  var page: Int!
  var pageControl = UIPageControl()
  
  var oneImage = UIImageView()
  var twoImage = UIImageView()
  var threeImage = UIImageView()
  var foureImage = UIImageView()
  var fiveImage = UIImageView()
  var sixImage = UIImageView()
  var sevenImage = UIImageView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let alphaAnimation = IFTTTAlphaAnimation(view:self.view)
      animator.addAnimation(alphaAnimation)
      let frame = self.view.bounds
      //scrollView的初始化
      
      scrollView.frame=self.view.bounds
      scrollView.delegate = self
      //为了能让内容横向滚动，设置横向内容宽度为4个页面的宽度总和
      scrollView.contentSize=CGSizeMake(frame.size.width*CGFloat(numOfPages),frame.size.height)
   
      scrollView.pagingEnabled=true
      scrollView.showsHorizontalScrollIndicator=false
      scrollView.showsVerticalScrollIndicator=false
      scrollView.scrollsToTop=false
      for i in 0..<numOfPages{
        let imgfile = "bg_\(i+1)"
        let image = UIImage(named:"\(imgfile)")
        foureImage = UIImageView(image: image)
        foureImage.frame=CGRectMake(frame.size.width*CGFloat(i),CGFloat(0),
          frame.size.width,frame.size.height)
        scrollView.addSubview(foureImage)
      }
      for i in 0..<2{
        let imgfile = "p_0"
        let image = UIImage(named:"\(imgfile)")
        let imgView = UIImageView(image: image)
        
        imgView.frame = CGRectMake(frame.size.width*CGFloat(i)+(frame.size.width-50)/2,200,
          50 ,240)
        scrollView.addSubview(imgView)
      }
      
      //页控件属性
      pageControl.frame = CGRectMake(frame.width/3,frame.height*0.8,frame.width/3,30)
      pageControl.backgroundColor = UIColor.clearColor()
      pageControl.numberOfPages = 4
      pageControl.currentPage = 0
      pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
      //设置页控件点击事件
      pageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
      scrollView.contentOffset = CGPointZero
      self.view.addSubview(scrollView)
      self.view.addSubview(pageControl)
      configureViews()
      configureAnimations()
      
    }
  
  override func scrollViewDidScroll(scrollView: UIScrollView)
  {
    animator.animate(scrollView.contentOffset.x)
    
    
    let twidth = CGFloat(numOfPages-1) * self.view.bounds.size.width
    if(scrollView.contentOffset.x > twidth)
    {
      let viewController = MainTBC()
      self.presentViewController(viewController, animated: true, completion:nil)
    }
  }
  
  override func numberOfPages() -> UInt {
    return 4
  }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
 
  override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = page
   
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
  }
  
 
  func pageChanged(sender:UIPageControl) {
    
    var frame = scrollView.frame
    frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
    frame.origin.y = 0
    scrollView.scrollRectToVisible(frame, animated:true)
  }

  func configureViews() {
    
    
    
    oneImage.image = UIImage(named: "p_2")
    self.contentView.addSubview(oneImage)
    
    twoImage.image = UIImage(named: "p_6")
    self.contentView .addSubview(twoImage)
    
    threeImage.image = UIImage(named: "p_4")
    self.contentView .addSubview(threeImage)
    
    fiveImage.image = UIImage(named: "p_5")
    self.contentView .addSubview(fiveImage)
    
    sixImage.image = UIImage(named: "p_1")
    self.contentView .addSubview(sixImage)
    
    sevenImage.image = UIImage(named: "p_3")
    self.contentView .addSubview(sevenImage)
  }
  
  func configureAnimations() {
    configureOneImageAnimations()
  }
  
  func configureOneImageAnimations() {
//   keepView(oneImage, onPages: [0,-1], atTimes: [0,1])
//    oneImage.mas_makeConstraints { (make:MASConstraintMaker!) -> Void in
//      make.top.equalTo()(self.view).offset()(200)
//      make.left.equalTo()(self.view).offset()(6)
//      make.height.equalTo()(self.contentView)
//      make.width.equalTo()(self.contentView)
//    }
   // keepView(oneImage, onPages: [0,1,0], atTimes: [0,1,0], withAttribute: IFTTTHorizontalPositionAttribute.Left)
  }
  
  

}
