//
//  ViewController.swift
//  testSwift
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var testView: UIView!
    var stuDic = Dictionary<String, String>()

    var namesOfIntegers = Dictionary<Int, String>()

    var a = 0
    var timerInterval = CGFloat(0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addScrollView()
        self.addTimer()
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.test), userInfo: nil, repeats: true)

        print(self.view.frame.height)
    }
    
    func test()  {
        //print("aaa")
        a += 1
        print(a,self.scrollView.contentOffset.y)
        
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

