//
//  YSGuideImgViewController.swift
//  Portal
//
//  Created by 陈晓克 on 16/9/2.
//  Copyright © 2016年 陈晓克. All rights reserved.
//

/// 具体承载引导图片的VC
import UIKit
class YSGuideImgViewController: UIViewController {
    
    private(set) lazy var imgview:UIImageView = {
        return UIImageView.init(frame:self.view.bounds)
    }()
    
    private(set) lazy var label:UILabel = {
        return UILabel.init(frame:CGRectMake((self.view.bounds.width-80)/2, (self.view.bounds.height-40)/2, 120, 40)
)
    }()
    
    private(set) lazy var beginBtn:UIButton = {
        return UIButton(type:.Custom)
    }()
    /**
     重写了初始化方法
     
     - parameter imgName: 使用到的图片名称
     - parameter frame:   图片的frame
     - parameter showBtn: 是否展示开始体验的按钮
     
     - returns:
     */
    init(imgName:String, frame:CGRect, showBtn:Bool){
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
       // self.view.addSubview(self.imgview)
        self.view.addSubview(self.label)
        //self.imgview.image = UIImage(named: imgName)
        self.label.text=imgName
        self.label.font=UIFont(name:"Zapfino", size:12)
        self.label.textAlignment=NSTextAlignment.Center
        self.label.center = CGPoint(x: self.view.bounds.width / 2,
                              y: self.view.bounds.height / 2)
        
        self.beginBtn.frame = CGRectMake((self.view.bounds.width-174)/2, self.view.bounds.height-40-82, 174, 36)
        self.beginBtn.setTitleColor(UIColor.blackColor(),forState: .Normal) //普通状态下文字的颜色
        //self.beginBtn.setImage(UIImage(named:"icon_pin"), forState: .Normal)
        self.beginBtn.setTitle(NSLocalizedString("Guide.start",comment:"Start"), forState: .Normal)
        self.beginBtn.backgroundColor=UIColor(red: 255, green: 255, blue: 0, alpha: 0.8)
        self.beginBtn.titleLabel?.font=UIFont(name:"Zapfino", size:14)
        self.beginBtn.layer.cornerRadius = 8;
        //self.beginBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        self.beginBtn.contentVerticalAlignment = .Center
        self.beginBtn.addTarget(self, action:#selector(beginBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.beginBtn)
        self.beginBtn.hidden = !showBtn
    }
    
    /**
     按钮点击事件
     */
    func beginBtnClicked() {
        let storyboard:UIStoryboard =  UIStoryboard(name: "Login", bundle: nil)
        presentViewController(storyboard.instantiateViewControllerWithIdentifier("login.main"), animated: false, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
