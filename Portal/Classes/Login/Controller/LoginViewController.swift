//
//  LoginViewController.swift
//  Portal
//
//  Created by 陈晓克 on 16/9/2.
//  Copyright © 2016年 陈晓克. All rights reserved.
//

import UIKit
class LoginViewController: FormViewController {
    private var progressView=UIProgressView(progressViewStyle:UIProgressViewStyle.Default)
    var timer: NSTimer!
    var remainTime = 0
    struct Static {
        static let passwordTag = "password"
        static let accountTag = "username"
        static let button = "button"
    }
    struct Ls {
        static let Submit = NSLocalizedString("Login.Submit",comment:"Submit")
        static let Return = NSLocalizedString("Login.Return",comment:"Return")
        static let LoginForm = NSLocalizedString("Login.LoginForm",comment:"LoginForm")
        static let Account = NSLocalizedString("Login.Account",comment:"Account")
        static let EnterAccount = NSLocalizedString("Login.EnterAccount",comment:"EnterAccount")
        static let Password = NSLocalizedString("Login.Password",comment:"Password")
        static let EnterPassword = NSLocalizedString("Login.EnterPassword",comment:"EnterPassword")
        static let Login = NSLocalizedString("Login.Login",comment:"Login")
        static let SystemLogin = NSLocalizedString("Login.SystemLogin",comment:"SystemLogin")
        static let Authority = NSLocalizedString("Login.Authority",comment:"Authority")
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Ls.Submit, style: .Plain, target: self, action: #selector(ExampleFormViewController.submit(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Ls.Return, style: .Plain, target: self, action:#selector(ExampleFormViewController.goback(_:)))
        
         self.initProgress()
    }
    func goback(_: UIBarButtonItem!) {
        NSLog("goback")
        let storyboard:UIStoryboard = UIStoryboard(name: "Guide", bundle: nil)
self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("guide.main"),animated: false, completion: nil)
    
    }
    // MARK: Actions
    func submit(_: UIBarButtonItem!) {
        let message = self.form.formValues().description
        let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        }
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    // MARK: Private interface
    private func loadForm() {
        let form = FormDescriptor(title: Ls.LoginForm)
        let section1 = FormSectionDescriptor(headerTitle: Ls.SystemLogin, footerTitle:Ls.Authority)
        var row = FormRowDescriptor(tag: Static.accountTag, type: .Email, title: Ls.Account)
        row.configuration.cell.appearance = ["textField.placeholder" : Ls.EnterAccount, "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.rows.append(row)
        row = FormRowDescriptor(tag: Static.passwordTag, type: .Password, title: Ls.Password)
        row.configuration.cell.appearance = ["textField.placeholder" : Ls.EnterPassword, "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.rows.append(row)
        let section8 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        row = FormRowDescriptor(tag: Static.button, type: .Button, title: Ls.Login)
        row.configuration.button.didSelectClosure = { _ in
            let storyboard:UIStoryboard = UIStoryboard(name: "Portal", bundle: nil)
    self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("portal.main"),animated: false, completion: nil)
        }
        section8.rows.append(row)
        form.sections = [section1,  section8]
        self.form = form
    }
    func initReqParam(){
        let urlString:String="http://127.0.0.1/cas/login"
        let url:NSURL! = NSURL(string:urlString)
        let request:NSURLRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request,
                                                   completionHandler: {(data, response, error) -> Void in
                                                    if error != nil{
                                                        print(error?.code)
                                                        print(error?.description)
                                                    }else{
                                                        let body = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                        let r = body!.rangeOfString("name=\"lt\"")
                                                        let lt=body!.substringWithRange(NSRange(location: r.location+17,length: 40)) as NSString
                                                        let r2=lt.rangeOfString("\"")
                                                        let lt2=lt.substringWithRange(NSRange(location: 0,length: r2.location))
                                                        self.login(lt2)
                                                    }
        }) as NSURLSessionTask
        dataTask.resume()
    }
    func login(lt:String){
        let post = String(format: "username=%@&password=%@&lt=%@&_eventId=%@&execution=%@&ch=%@", "admin", "123123", lt,"submit","e1s1","on")
        let postData: NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        NSLog(lt)
        let urlString:String="http://127.0.0.1/cas/login"
        let url:NSURL! = NSURL(string:urlString)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        //request.HTTPBody = postData
        let session = NSURLSession.sharedSession()
        let dataTask = session.uploadTaskWithRequest(request,fromData: postData,
                                                     completionHandler: {(data, response, error) -> Void in
                                                        if error != nil{
                                                            print(error?.code)
                                                            print(error?.description)
                                                        }else{
                                                            let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                                                            let ck=httpResponse.allHeaderFields["Set-Cookie"]
                                                            let dic=ck as! String
                                                            if(dic.rangeOfString("CASTGC")==nil){
                                                                print("false")
                                                            }else{
                                                                print("true")
                                                                self.getCfg()
                                                            }
                                                        }
        }) as NSURLSessionTask
        dataTask.resume()
    }
    func getCfg(){
        let urlString:String="http://127.0.0.1/portal/system/getContextCfg.do"
        let url:NSURL! = NSURL(string:urlString)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request,
                                                   completionHandler: {(data, response, error) -> Void in
                                                    if error != nil{
                                                        print(error?.code)
                                                        print(error?.description)
                                                    }else{
                                                        let json : AnyObject! = try?NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments)
                                                        print(json.objectForKey("cfg")?.objectForKey("sys_name"));
                                                    }
                                                    
        }) as NSURLSessionTask
        dataTask.resume()
        
        
    }
    private func initProgress(){
        progressView.center=self.view.center
        progressView.progress=0.1 //默认进度50%
        //progressView.progressTintColor=UIColor.blueColor() //已有进度颜色
        //progressView.trackTintColor=UIColor.whiteColor() //剩余进度颜色（即进度槽颜色）
        progressView.alpha=1
        progressView.hidden=false
        progressView.transform = CGAffineTransformMakeScale(1.0, 2.0)
        self.view.addSubview(progressView);
        //NSThread.detachNewThreadSelector("setProgress", toTarget: self, withObject: nil);
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "timerAction", userInfo: nil, repeats:true)
        timer.fire()
    }
    public func setProgress(){
        for index in 1...100 {
            self.progressView.setProgress(Float(index)/100,animated:true)
            NSThread.sleepForTimeInterval(0.5)
            NSLog("index at %i",index)
        }
    }
    func timerAction() {
        if(remainTime > 100){
            //倒计时结束
            timer.invalidate()
            progressView.hidden=true
        } else {
            print("\(remainTime)")
            remainTime = remainTime + 1
            let progressValue = Float(remainTime)/100
            progressView.setProgress(progressValue, animated:true)
        }
    }
}
