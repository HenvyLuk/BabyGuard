//
//  ViewController.swift
//  testSwift
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var testView: UIView!
    var stuDic = Dictionary<String, String>()

    var namesOfIntegers = Dictionary<Int, String>()
    
    var arr = [1,2,6,9,7,0]
    
    var rect: CGRect {
        get{
       let re = self.testView.frame
            return re
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(rect)
        
        
        //let name = "2016072"
        
        //let year = (name as NSString).substringToIndex(4)
   
        //let mon = (name as NSString).substringWithRange(NSMakeRange(4, 2))
        
        //let day = (name as NSString).substringFromIndex(6)
        
        
        
//        print(year)
//        print(mon)
//        print(day)
        //print(most)
        
        let a = arr.maxElement()
        print(a)
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testBtn(sender: AnyObject) {
        let he = UIScreen.mainScreen().bounds.height
        
//        UIView.animateWithDuration(0.5, animations: {
//            self.testView.frame = CGRectMake(0, he - self.testView.frame.height * 2 , self.testView.bounds.size.width, self.testView.bounds.size.height)
//        }) { (true) in
//            print("ccccc")
//        }

        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
               self.testView.frame = CGRectMake(0, he - self.testView.frame.height , self.testView.bounds.size.width, self.testView.bounds.size.height)
            }) { (true) in
                
        }
  
        
    }
    @IBAction func testBtn2(sender: AnyObject) {
        let he = UIScreen.mainScreen().bounds.height

        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.testView.frame = CGRectMake(0, he + self.testView.frame.height , self.testView.bounds.size.width, self.testView.bounds.size.height)
            }) { (true) in
                
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

