//
//  YSGuideViewController.swift
//  Portal
//
//  Created by 陈晓克 on 16/9/2.
//  Copyright © 2016年 陈晓克. All rights reserved.
//

import UIKit

class YSGuideViewController: UIViewController {

    private(set) lazy var pageControl:UIPageControl = {
        return UIPageControl(frame:CGRectMake((self.view.bounds.width-200)/2,self.view.bounds.height-20-10,200,20))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(removeGuidePageView), name: "beginExperience", object: nil)
        //self.view.backgroundColor = UIColor(patternImage:UIImage(named: "Image1")!)
        self.view.backgroundColor=UIColor(red: 0, green: 191, blue: 255, alpha: 0.8)
        self.view.addSubview(pageControl)
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        loadGuidePageView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(Bool())
        let firstDispalyKey:String = "firstDispalyKey"
        let firstDispaly: String? = KeychainWrapper.stringForKey(firstDispalyKey)
        if(firstDispaly==nil){
            KeychainWrapper.setString("CHENXIAOKE", forKey:firstDispalyKey)
            NSLog("FirstDispaly")
        }else{
            NSLog(firstDispaly!)
            //let storyboard:UIStoryboard =  UIStoryboard(name: "Login", bundle: nil)
            //presentViewController(storyboard.instantiateViewControllerWithIdentifier("login.main"), animated: false, completion: nil)
            KeychainWrapper.removeObjectForKey(firstDispalyKey)
        }
        

    }
    
    func loadGuidePageView() {
        let guideview = YSGuidePageViewController.init(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil, pageCount: { (guide:YSGuidePageViewController, count:NSInteger) in
            self.pageControl.numberOfPages = count
            },pageIndex: {(guide:YSGuidePageViewController, index:NSInteger) in
                self.pageControl.currentPage = index
        })//Scroll
        guideview.view.frame = self.view.bounds
        self.view.addSubview(guideview.view)
        self.addChildViewController(guideview)
        self.view.bringSubviewToFront(pageControl)
        self.addChildViewController(guideview)
    }
    
    
    /**
     移除引导页,同时记录引导页已经显示完成
     */
    func removeGuidePageView() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        //Todo:存储第一次已经显示引导页
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
