//
//  ViewController.swift
//  testSwift
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIAlertViewDelegate{
    @IBOutlet weak var testBtn: UIButton!

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var testView: UIView!
    var stuDic = Dictionary<String, String>()

    var namesOfIntegers = Dictionary<Int, String>()

    var a = 0
    var timerInterval = CGFloat(0)
    
    
    
    @IBAction func testAction(sender: AnyObject) {
        let positionAnimation = POPSpringAnimation(propertyNamed: "positionX")
        //positionAnimation.velocity = 10000
        positionAnimation.springBounciness = 20
        self.testBtn.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.view.backgroundColor.debugDescription)
        
        self.addScrollView()
        self.addTimer()
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.test), userInfo: nil, repeats: true)

        print(self.view.frame.height)
    }
    
    func test()  {
        //print("aaa")
        a += 1
        //print(a,self.scrollView.contentOffset.y)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        let date = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale.currentLocale()
//        dateFormatter.dateFormat = "MM.dd"
//        let convertedDate = dateFormatter.stringFromDate(date)
//        let str = convertedDate.stringByReplacingOccurrencesOfString("0", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var str = "0808"
        let index = str.startIndex.advancedBy(2)
        
        str.insert(".", atIndex: index)
        
        
        print(str)
        
        
        
        
        
        
        
        
        //let alertView = UIAlertView()
//        alertView.delegate = self
//        alertView.title = "Title"
//        alertView.message = "Message"
//        alertView.addButtonWithTitle("OK")
//        alertView.show()
        
        
        
        
        //var alertView = UIAlertView(title: "提示", message: "qqqqqq", delegate: self, cancelButtonTitle: "确定")
        ///alertView.show()
        //self.performSelector(#selector(ViewController.dissmiss), withObject: alertView, afterDelay: 1.0)
        
    }
//    func dissmiss(withAlertView alertView: UIAlertView) {
//        
//            print("dddddddd")
//            alertView.dismissWithClickedButtonIndex(0, animated: true)
//            
//
//    }

    
    func tetstClick()  {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewControllerWithIdentifier("1")
        self.presentViewController(vc, animated: true) {
            print("p1")
        }
    }

    func addScrollView()  {
        self.scrollView.delegate = self
        
        for i in 1..<3 {
            let imageViewX = CGFloat(0)
            let imageViewY = CGFloat(i - 1)  * (self.scrollView.frame.height)
            let imageViewW = self.view.bounds.size.width
            let imageViewH = self.scrollView.frame.height
            
            let myImageView = UIImageView.init(frame: CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH))
            let name = String(i)
            
            myImageView.image = UIImage(named: name)
            self.scrollView.addSubview(myImageView)
        }
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.frame.height * 2)
    }
    
    
    func addTimer()  {
        let bottomOffset = CGPointMake(0, self.view.bounds.size.height * 0.5)
        let scrollDurationInSeconds = CGFloat(2.0)
        
        let totalScrollAmount = CGFloat(bottomOffset.y)
        let timerInterval = scrollDurationInSeconds / totalScrollAmount
        self.timerInterval = timerInterval
        NSTimer.scheduledTimerWithTimeInterval(Double(timerInterval), target: self, selector: #selector(ViewController.cycleImage), userInfo: nil, repeats: true)
        
        //#selector(LoginViewController.cycleImage)
    }
    
    func cycleImage(withTimer timer: NSTimer) {
        var newScrollViewContentOffset = self.scrollView.contentOffset
        newScrollViewContentOffset.y += 1
        self.scrollView.contentOffset = newScrollViewContentOffset
        if (newScrollViewContentOffset.y == self.view.frame.size.height * 0.5) {
            timer.invalidate()
            print("qqqqqqq")
            NSTimer.scheduledTimerWithTimeInterval(Double(timerInterval), target: self, selector: #selector(ViewController.cycleImage2), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func cycleImage2(withTimer timer: NSTimer) {
        var newScrollViewContentOffset = self.scrollView.contentOffset
        newScrollViewContentOffset.y -= 1
        self.scrollView.contentOffset = newScrollViewContentOffset
        if (newScrollViewContentOffset.y == 0) {
            timer.invalidate()
            print("wwwwwww")
            NSTimer.scheduledTimerWithTimeInterval(Double(timerInterval), target: self, selector: #selector(ViewController.cycleImage), userInfo: nil, repeats: true)

            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

