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
        
       
        for i in 0..<5 {
        
            //self.stuDic.setValue("aaaaa", forKey: String(i))
            self.stuDic[String(i)]="aaaaa"
        }
 
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testBtn(sender: AnyObject) {
        
        print(self.stuDic)
        

  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

