//
//  ViewController.swift
//  BabyGuard
//
//  Created by csh on 16/6/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UIAlertViewDelegate{

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tipsView: UIView!
    var seatTableViewController = SeatTableViewController()
    var signStatusTableViewController = SignStatusTableViewController()
    
    var procSeatArray = [SeatInfo]()
    var isLastOPAtAM = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.popPrecious))
        self.navigationItem.leftBarButtonItem = leftItem
        
        if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 5 {
            coverView.hidden = true
            self.seatTableViewController = SeatTableViewController.init(style: UITableViewStyle.Plain)
            self.addChildViewController(self.seatTableViewController)
            self.seatTableViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)
            self.contentView.addSubview(self.seatTableViewController.view)
        
            
            let tools = UIToolbar.init(frame: CGRectMake(0, 0, 100, 45))
            tools.backgroundColor = UIColor.redColor()
            
            var buttons = [UIBarButtonItem]()
            let button1 = UIBarButtonItem.init(title: "签到", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.signInBtn))
            let button2 = UIBarButtonItem.init(title: "查询", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.makeEnquiriesBtn))
            
            buttons.append(button1)
            buttons.append(UIBarButtonItem.init(customView: UIView.init(frame: CGRectMake(0, 0, 15, 45))))
            buttons.append(button2)
            tools.setItems(buttons, animated: true)
            
            let myBtn = UIBarButtonItem.init(customView: tools)
            self.navigationItem.rightBarButtonItem = myBtn
            
        }else if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 1 {
            
            self.signStatusTableViewController = SignStatusTableViewController.init(style: UITableViewStyle.Plain)
            self.addChildViewController(self.signStatusTableViewController)
            self.signStatusTableViewController.view.frame = CGRectMake(0 ,0 ,self.contentView.frame.size.width, self.contentView.frame.size.height)
            self.contentView.addSubview(self.signStatusTableViewController.view)

            let right = UIBarButtonItem(title: "查询周", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.makeEnquiriesBtn))
            self.navigationItem.rightBarButtonItem = right
            
            
            let nextRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.nextPageSwipe))
            nextRecognizer.direction = UISwipeGestureRecognizerDirection.Down
            coverView.addGestureRecognizer(nextRecognizer)
            let preRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.previousPageSwipe))
            nextRecognizer.direction = UISwipeGestureRecognizerDirection.Up
            coverView.addGestureRecognizer(preRecognizer)
            
            
        }
        
    }
    
    func nextPageSwipe() {
        print("1")
        let animation = CATransition()
        animation.duration = 0.7
        animation.type = "pageCurl"
        animation.subtype = kCATransitionFromBottom
        self.view.layer.addAnimation(animation, forKey: "animation")
        
        signStatusTableViewController.changeDateStr()
        
    }
    
    
    func previousPageSwipe() {
        print("2")
        let animation = CATransition()
        animation.duration = 0.7
        animation.type = "pageUnCurl"
        animation.subtype = kCATransitionFromTop
        
        self.view.layer.addAnimation(animation, forKey: "animation")
        
    }
    
    func signInBtn() {
        if ApplicationCenter.defaultCenter().lanDomain == "" {
            AlertHelper.showConfirmAlert("没有连接到内网服务器，请选择", delegate: self, type: NSInteger(Definition.ALERT_NO_LAN_DOMAIN)!)
            return
        }
        procSeatArray.removeAll()
        let isAM = ToolHelper.isNowAM()
        isLastOPAtAM = isAM
        
        let userIDArray = seatTableViewController.stuDic.keys
        for userID in userIDArray {
            let seatInfo = seatTableViewController.stuDic[userID]
            
            if !(seatInfo?.isSelected)! {
                continue
            }
            if isAM && seatInfo!.amSignStatus == .SignStatusNo {
                procSeatArray.append(seatInfo!)
            }else if isAM && seatInfo?.pmSignStatus == .SignStatusNo {
                procSeatArray.append(seatInfo!)
            }
            
        }
        if procSeatArray.count == 0 {
            AlertHelper.showConfirmAlert("没有学生需要签到", delegate: nil, type: 0)
        }
        var parameters = Dictionary<String, String>()
        parameters["Key"] = "Time"
        parameters["QdType"] = String(SignStatus.SignStatusManual.rawValue)
        let users = NSMutableString()
        for i in 0..<procSeatArray.count{
            let seatInfo = procSeatArray[i]
            if i < procSeatArray.count - 1 {
                users.appendString(seatInfo.userInfo!.userID + "," + seatInfo.userInfo!.userName + "#")
            }else {
                users.appendString(seatInfo.userInfo!.userID + "," + seatInfo.userInfo!.userName)
            }
            
        }
        parameters["Users"] = users as String
        let urlStr = Definition.lanSignInURL(withDomain: seatTableViewController.serUrlArr)
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: parameters, filePath: nil, progress: nil, success: self.postSignSuc, cancel: {}, failure: self.postSignFail)
        
    }
    
    func postSignSuc(data: String) {
        print("data:\(data)")
        
        
    }
    func postSignFail(data: String) {
        
    }
    
    func pushSignStatus() {
        if ApplicationCenter.defaultCenter().lanDomain == "" {
            AlertHelper.showConfirmAlert("没有连接到内网服务器，请选择", delegate: self, type: NSInteger(Definition.ALERT_NO_LAN_DOMAIN)!)
            return
        }
        let isAM = ToolHelper.isNowAM()
        isLastOPAtAM = isAM
        procSeatArray.removeAll()

        let userIDArray = seatTableViewController.stuDic.keys
        for userID in userIDArray {
            let seatInfo = seatTableViewController.stuDic[userID]
            
            if !(seatInfo?.isSelected)! {
                continue
            }
            if isAM {
                if seatInfo!.amSignStatus == .SignStatusCard || seatInfo!.amSignStatus == .SignStatusManual {
                    procSeatArray.append(seatInfo!)
                }else if seatInfo!.pmSignStatus == .SignStatusCard || seatInfo!.pmSignStatus == .SignStatusManual {
                    procSeatArray.append(seatInfo!)

                }
            }
            
        }
        if procSeatArray.count == 0 {
            AlertHelper.showConfirmAlert("没有学生签到信息需要推送", delegate: nil, type: 0)
        }
        var parameters = Dictionary<String, String>()
        parameters[Definition.KEY_URL_CHECK_ID] = Definition.PART_URL_CHECK_ID
        parameters[Definition.KEY_URL_USER_ID] = ApplicationCenter.defaultCenter().curUser?.userID
        parameters[Definition.KEY_URL_POST_TYPE] = Definition.PART_URL_PUSH_SIGNIN
        parameters[Definition.KEY_URL_TITLE] = "到离校推送"
        
        if isAM {
            parameters[Definition.KEY_URL_INFO] = "您的孩子$$_PNAME_$$于$$_STIME_$$$$_DXLX_$$到校"
        } else {
            parameters[Definition.KEY_URL_INFO] = "您的孩子$$_PNAME_$$于$$_STIME_$$$$_DXLX_$$离校"
        }
        
        let users = NSMutableString()
        for i in 0..<procSeatArray.count{
            let seatInfo = procSeatArray[i]
            if i < procSeatArray.count - 1 {
                if isAM {
                    users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.amSignTime! + ",")
                }else {
                    users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.pmSignTime! + ",")

                }
                
            }else {
                if isAM {
                    users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.amSignTime!)
                }else {
                   users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.pmSignTime!)
                }
                
                
            }
            
        }
        
        
        parameters[Definition.KEY_URL_POST_ITEM_ID] = users as String
        
        let urlStr = Definition.postTextUrl(withDomain: seatTableViewController.serUrlArr)
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: parameters, filePath: nil, progress: nil, success: self.postTextSuc, cancel: {}, failure: self.postTextFail)
        
        
    }
    func postTextSuc(data: String) {
        print("data2:\(data)")
    }
    func postTextFail(data: String) {
        
    }
    
    func makeEnquiriesBtn() {
        let sto = UIStoryboard(name: "Main", bundle: nil)
        let calendarViewCon = sto.instantiateViewControllerWithIdentifier("calendar")
        
        calendarViewCon.transitioningDelegate = self
        
        calendarViewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.navigationController?.presentViewController(calendarViewCon, animated: true, completion: nil)
        
    }
    
    func popPrecious() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return TopAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return TopDisAnimator()
    }
    
    @IBAction func curbClick(sender: AnyObject) {
        


        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

