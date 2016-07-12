//
//  ViewController.swift
//  BabyGuard
//
//  Created by csh on 16/6/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    var seatTableViewController = SeatTableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.seatTableViewController = SeatTableViewController.init(style: UITableViewStyle.Plain)
        self.addChildViewController(self.seatTableViewController)
        self.seatTableViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)
        self.contentView.addSubview(self.seatTableViewController.view)
        
        
        let rightItem = UIBarButtonItem(title: "查询", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.makeEnquiriesBtn))
        self.navigationItem.rightBarButtonItem = rightItem
        let leftItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.popPrecious))
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        
        
    }
    
    func makeEnquiriesBtn() {
        print("sssss")
    }
    
    func popPrecious() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

