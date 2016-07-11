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
        
        let name = "1234:5678999"
        
        let range = (name as NSString).rangeOfString(":")
   
        let new = (name as NSString).substringToIndex(range.location)
        
        let most = (name as NSString).substringFromIndex(range.location + range.length)
        
        
        //print(new)
        //print(most)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testBtn(sender: AnyObject) {
        
        var dic:Dictionary<String,String> = ["1":"aaa","2":"bbb","3":"ccc"]
        
        print(dic)

  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

