//
//  ViewController.swift
//  testSwift
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var stuDic = Dictionary<String, String>()

    var namesOfIntegers = Dictionary<Int, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = "2016072"
        
        let year = (name as NSString).substringToIndex(4)
   
        let mon = (name as NSString).substringWithRange(NSMakeRange(4, 2))
        
        let day = (name as NSString).substringFromIndex(6)
        
        
        
        print(year)
        print(mon)
        print(day)
        //print(most)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testBtn(sender: AnyObject) {
        

  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

