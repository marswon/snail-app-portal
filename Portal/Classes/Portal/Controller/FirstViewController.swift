//
//  FirstViewController.swift
//  Tabmutiview
//
//  Created by 陈晓克 on 16/2/27.
//  Copyright © 2016年 陈晓克. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func eureka(sender: AnyObject) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Eureka", bundle: nil)
        self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("eureka.main"),animated: false, completion: nil)
    }
}

