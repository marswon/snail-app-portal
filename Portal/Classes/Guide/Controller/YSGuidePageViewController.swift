//
//  YSGuidePageViewController.swift
//  Portal
//
//  Created by 陈晓克 on 16/9/2.
//  Copyright © 2016年 陈晓克. All rights reserved.
//

import UIKit
/// 引导页
class YSGuidePageViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    /// 页面数量改变时的回调
    var pageViewControllerUpdatePageCount:((YSGuidePageViewController,NSInteger)->Void)!
    /// 页面改变时的回调
    var pageViewControllerUpdatePageIndex:((YSGuidePageViewController,NSInteger)->Void)!
    
    private(set) lazy var allViewControllers:[UIViewController]={
        return [YSGuideImgViewController(imgName: "向导视图一",frame: self.view.bounds, showBtn:false),
                YSGuideImgViewController(imgName: "向导视图二",frame: self.view.bounds, showBtn:false),
                YSGuideImgViewController(imgName: "向导视图三",frame: self.view.bounds,showBtn:true)]
    }()
    
    internal init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?, pageCount:((YSGuidePageViewController,NSInteger)->Void)!, pageIndex:((YSGuidePageViewController,NSInteger)->Void)!) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.pageViewControllerUpdatePageCount = pageCount
        self.pageViewControllerUpdatePageIndex = pageIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
       
        //设置首页
        if let firstViewController = allViewControllers.first {
            setViewControllers([firstViewController], direction: .Forward, animated: true, completion:nil)
        }
        
        //页面数量改变时
        if self.pageViewControllerUpdatePageCount != nil {
            self.pageViewControllerUpdatePageCount(self,allViewControllers.count)
        }
    }
    
    //mark:获取前一个页面
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        //guard 条件为false就执行else里的函数块
        guard let viewControllerIndex = allViewControllers.indexOf(viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard allViewControllers.count > previousIndex else {
            return nil
        }
        return allViewControllers[previousIndex]
    }
    
    //mark:获取后一个页面
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = allViewControllers.indexOf(viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = allViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount>nextIndex else {
            return nil
        }
        return allViewControllers[nextIndex]
    }
    
    //mark:页面切换完毕
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,let index = allViewControllers.indexOf(firstViewController) {
            if self.pageViewControllerUpdatePageIndex != nil {
                self.pageViewControllerUpdatePageIndex(self,index)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

