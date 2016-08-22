//
//  testViewController.swift
//  testSwift
//
//  Created by csh on 16/8/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var testBtn: UIButton!
    
    @IBOutlet weak var testBtn2: UIButton!
    
    
    @IBAction func testAction(sender: AnyObject) {
        
        
            //需要长时间处理的代码
//            for i in 0..<10000 {
//                print(i)
//            }
            let concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT)
           // dispatch_sync(concurrentQueue){
                //NSThread.sleepForTimeInterval(1)
                for i in 0..<100000 {
                print(i)
            }
                
            //}
        dispatch_async(dispatch_get_main_queue(), {
            //需要主线程执行的代码
            self.testBtn.userInteractionEnabled = true
            
            let positionAnimation = POPSpringAnimation(propertyNamed: "positionX")
            positionAnimation.velocity = 10000
            positionAnimation.springBounciness = 20
            self.testBtn.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
            
            
        })
    
        
        
//        let tr = CABasicAnimation.init(keyPath: "transform.translation.x")
//        tr.fromValue = 20
//        tr.toValue = 150
//        self.testBtn2.layer.addAnimation(tr, forKey: "positionX")
                print("a")
            
            
            
          
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
