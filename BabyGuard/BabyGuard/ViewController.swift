//
//  ViewController.swift
//  BabyGuard
//
//  Created by csh on 16/6/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

let OpenAnimationTime: Double = 0.3;
let DefaultOffset: Float = Float(UIScreen.mainScreen().bounds.size.width/2)

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UIAlertViewDelegate, SlideMenuAnimatedTransitionDelegate{



    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var push: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var mainBtnView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tipsView: UIView!
    var seatTableViewController = SeatTableViewController()
    var signStatusTableViewController = SignStatusTableViewController()
    
    var procSeatArray = [SeatInfo]()
    var isLastOPAtAM = Bool()
    var hud = MBProgressHUD()
    var lastOP = ""
    
    var temp = ""
    
    let animatedTransition = SlideMenuAnimatedTransition()
    let interactiveTransition = UIPercentDrivenInteractiveTransition()
    var interactivelyTransitioning: Bool = false
    var leftScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var rightScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var leftViewControllerPresented: Bool {
        guard let leftViewController = self.leftViewController else {
            return false
        }
        
        return (!leftViewController.isBeingPresented()
            && leftViewController.presentingViewController != nil)
    }

    var rightViewControllerPresented: Bool {
        guard let rightViewController = self.rightViewController else {
            return false
        }
        
        return (!rightViewController.isBeingPresented()
            && rightViewController.presentingViewController != nil)
    }
    
    var leftViewController: UIViewController?
    var rightViewController: UIViewController?
//    var mainViewController: UIViewController? {
//        willSet {
//            if let mainViewController = self {
//                mainViewController.willMoveToParentViewController(nil)
//                mainViewController.view.removeFromSuperview()
//                mainViewController.removeFromParentViewController()
//            }
//        }
//        
//        didSet {
//            if let mainViewController = self.mainViewController {
//                addChildViewController(mainViewController)
//                
//                let view = mainViewController.view
//                view.frame = self.view.bounds
//                view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//                self.view.addSubview(view)
//                
//                mainViewController.didMoveToParentViewController(self)
//            }
//        }
//    }
    var animationDuration: NSTimeInterval {
        set {
            animatedTransition.animationDuration = newValue
        }
        
        get {
            return animatedTransition.animationDuration
        }
    }
    var completionThreshold: CGFloat = 0.15
    var revealAmount: CGFloat {
        set {
            animatedTransition.revealAmount = newValue
        }
        
        get {
            return animatedTransition.revealAmount
        }
    }
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//        commonInit()
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        commonInit()
//    }
    func commonInit() {
        animatedTransition.delegate = self
        interactiveTransition.completionCurve = .EaseOut
        
        setUpScreenEdgePanGestureRecognizers()
    }
    
    func setUpScreenEdgePanGestureRecognizers() {
        leftScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ViewController.handleScreenEdgePanGesture(_:)))
        leftScreenEdgePanGestureRecognizer.edges = [.Left]
        view.addGestureRecognizer(leftScreenEdgePanGestureRecognizer)
        
        rightScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ViewController.handleScreenEdgePanGesture(_:)))
        rightScreenEdgePanGestureRecognizer.edges = [.Right]
        view.addGestureRecognizer(rightScreenEdgePanGestureRecognizer)
    }
    
    func handleScreenEdgePanGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        temp = "left"

        let left = (gestureRecognizer == leftScreenEdgePanGestureRecognizer)
        let location = gestureRecognizer.translationInView(gestureRecognizer.view)
        let progress: CGFloat
        if left {
            progress = max(0, min(location.x / revealAmount, 1.0))
        } else {
            progress = max(0, min(-location.x / revealAmount, 1.0))
        }
        
        switch gestureRecognizer.state {
        case .Began:
            interactivelyTransitioning = true
            
            if left {
                presentLeftViewControllerAnimated(true, completion: nil)
            } else {
                presentRightViewControllerAnimated(true, completion: nil)
            }
            
        case .Changed:
            interactiveTransition.updateInteractiveTransition(progress)
            
        case .Cancelled, .Ended, .Failed:
            interactiveTransition.completionSpeed = completionSpeedForProgress(progress)
            
            if progress > completionThreshold {
                interactiveTransition.finishInteractiveTransition()
            } else {
                interactiveTransition.cancelInteractiveTransition()
            }
            
            interactivelyTransitioning = false
            
        default:
            break
        }
    }

    
    // MARK: - Interactive Transition
    
    private func completionSpeedForProgress(progress: CGFloat) -> CGFloat {
        return 1.25
    }
    
    
    // MARK: - Managing Menu View Controllers
    
    func presentLeftViewControllerAnimated(animated: Bool, completion: (() -> Void)?) {
        guard let leftViewController = self.leftViewController else {
            return
        }
        
        animatedTransition.transitionDirection = .Left
        
        presentMenuViewController(leftViewController, animated: animated, completion: completion)
    }
    
    func presentRightViewControllerAnimated(animated: Bool, completion: (() -> Void)?) {
        guard let rightViewController = self.rightViewController else {
            return
        }
        
        animatedTransition.transitionDirection = .Right
        
        presentMenuViewController(rightViewController, animated: animated, completion: completion)
    }
    
    func presentMenuViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .OverFullScreen
        
        presentViewController(viewController, animated: animated, completion: completion)
    }
    
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivelyTransitioning ? interactiveTransition : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivelyTransitioning ? interactiveTransition : nil
    }
    
    
    // MARK: - SlideMenuAnimatedTransitionDelegate
    
    func slideMenuAnimatedTransition(slideMenuAnimatedTransition: SlideMenuAnimatedTransition, handleTapGesture tapGestureRecognizer: UITapGestureRecognizer) {
        print("tap")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func slideMenuAnimatedTransition(slideMenuAnimatedTransition: SlideMenuAnimatedTransition, handlePanGesture panGestureRecognizer: UIPanGestureRecognizer) {
        let location = panGestureRecognizer.translationInView(panGestureRecognizer.view)
        let progress: CGFloat
        if leftViewControllerPresented {
            progress = max(0, min(-location.x / revealAmount, 1.0))
        } else {
            progress = max(0, min(location.x / revealAmount, 1.0))
        }
        
        switch panGestureRecognizer.state {
        case .Began:
            interactivelyTransitioning = true
            dismissViewControllerAnimated(true, completion: nil)
            
        case .Changed:
            interactiveTransition.updateInteractiveTransition(progress)
            
        case .Cancelled, .Ended, .Failed:
            interactiveTransition.completionSpeed = completionSpeedForProgress(progress)
            
            if progress > completionThreshold {
                interactiveTransition.finishInteractiveTransition()
            } else {
                interactiveTransition.cancelInteractiveTransition()
            }
            interactivelyTransitioning = false
            
        default:
            break
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menu = UIStoryboard(name: "Menu", bundle: nil)
        
        //let mainViewController = storyboard.instantiateViewControllerWithIdentifier("class")
        let leftViewController = menu.instantiateViewControllerWithIdentifier("LeftViewController")
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController")
        
        //self.mainViewController = self
        self.leftViewController = leftViewController
        self.rightViewController = rightViewController
        
         //let mainViewController = self
            //addChildViewController(mainViewController)
            
//            let view = self.view
//            view.frame = self.view.bounds
//            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//            //self.view.addSubview(view)
//            
//            self.didMoveToParentViewController(self)
        
        
        commonInit()

        let leftItem = UIBarButtonItem(title: "菜单", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.openCompletelyAnimated))
        self.navigationItem.leftBarButtonItem = leftItem
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.popPrecious), name: "popClassList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.pushSelfInfo), name: "pushSelfInfo", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.pushAboutSelf), name: "pushAboutSelf", object: nil)
        
        if ApplicationCenter.defaultCenter().curUser?.userLevel?.rawValue == 5 {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.mainBtnViewShow), name: "mainViewMenuShow", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.mainBtnViewHide), name: "mainViewMenuHide", object: nil)
            
            
            
            self.seatTableViewController = SeatTableViewController.init(style: UITableViewStyle.Plain)
            self.addChildViewController(self.seatTableViewController)
            self.seatTableViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)
            self.contentView.addSubview(self.seatTableViewController.view)

            let rbtn = UIBarButtonItem.init(title: "查询", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.makeEnquiriesBtn))
            self.navigationItem.rightBarButtonItem = rbtn
            
            self.coverView.hidden = true
            
            
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
            
            self.coverView.hidden = false

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
        
        signStatusTableViewController.previousWeek()

        
    }

    @IBAction func leftBtnClick(sender: AnyObject) {
        print("leftbtn")
        self.signInBtn()
    }
  
    func signInBtn() {
        if ApplicationCenter.defaultCenter().lanDomain == "" {
            AlertHelper.showConfirmAlert("没有连接到内网服务器，请返回重试", delegate: self, type: NSInteger(Definition.ALERT_NO_LAN_DOMAIN)!)
            return
        }
        let isAM = ToolHelper.isNowAM()
        isLastOPAtAM = isAM
        procSeatArray.removeAll()

        let userIDArray = Array(seatTableViewController.stuDic.keys)
        for userID in userIDArray {
            let seatInfo = seatTableViewController.stuDic[userID]
            if (!(seatInfo?.isSelected)!) {
                continue
            }
            if  seatInfo!.amSignStatus == .SignStatusNo {
                procSeatArray.append(seatInfo!)
            }else if seatInfo?.pmSignStatus == .SignStatusNo {
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
        
        hud.show(true)
        self.lastOP = "SIGNIN"
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: parameters, filePath: nil, progress: nil, success: self.postSignSuc, cancel: {}, failure: self.postSignFail)
        
    }
    
    @IBAction func pushBtnClick(sender: AnyObject) {
        print("rightBtn")
        self.pushSignStatus()

    }
    
    func postSignSuc(data: String) {
        print("data:\(data)")
        let content = XConnectionHelper.contentOfWanServerSampleString(data)
        if content != nil {
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                if lastOP == "SIGNIN" {
                    if isLastOPAtAM {
                        for seatInfo in self.procSeatArray {
                            seatInfo.amSignStatus = .SignStatusManual
                        }
                    }else {
                        for seatInfo in self.procSeatArray {
                            seatInfo.pmSignStatus = .SignStatusManual
                        }
                    }
                }else {
                    if isLastOPAtAM {
                        for seatInfo in self.procSeatArray {
                            if seatInfo.amSignStatus == .SignStatusCard {
                               seatInfo.amSignStatus = .SignStatusCPushed
                            }else if seatInfo.amSignStatus == .SignStatusManual {
                               seatInfo.amSignStatus = .SignStatusMPushed
                            }
                        }
                    }else{
                        for seatInfo in self.procSeatArray {
                            if (seatInfo.pmSignStatus == .SignStatusCard) {
                                seatInfo.pmSignStatus = .SignStatusCPushed
                            }else if seatInfo.pmSignStatus == .SignStatusManual {
                                seatInfo.pmSignStatus = .SignStatusMPushed
                            }
                    }
                }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.hud.hide(true)
                    self.seatTableViewController.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem?.customView

                })
            }else {
                switch self.lastOP {
                case "SIGNIN":
                    AlertHelper.showConfirmAlert("未能手动签到", delegate: nil, type: 0)
                case "OPERATION_PUSH":
                    AlertHelper.showConfirmAlert("未能推送", delegate: nil, type: 0)
                default:
                    break
                }
            }
        
        }
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

        let userIDArray = Array(seatTableViewController.stuDic.keys)
        for userID in userIDArray {
            let seatInfo = seatTableViewController.stuDic[userID]
            
            if !(seatInfo?.isSelected)! {
                continue
            }
            if isAM {
                if seatInfo!.amSignStatus == .SignStatusCard || seatInfo!.amSignStatus == .SignStatusManual {
                    procSeatArray.append(seatInfo!)
                }
            }else {
                if seatInfo!.pmSignStatus == .SignStatusCard || seatInfo!.pmSignStatus == .SignStatusManual {
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
                    users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.amSignTime + ",")
                }else {
                    users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.pmSignTime + ",")

                }
                
            }else {
                if isAM {
                    users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.amSignTime)
                }else {
                   users.appendString(seatInfo.userInfo!.userID + "#" + seatInfo.userInfo!.personName + "#" + seatInfo.pmSignTime)
                }
                
                
            }
            
        }
        
        
        parameters[Definition.KEY_URL_POST_ITEM_ID] = users as String
        
        let urlStr = Definition.postTextUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!)
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: parameters, filePath: nil, progress: nil, success: self.postTextSuc, cancel: {}, failure: self.postTextFail)
        
        
    }
    
    func postTextSuc(data: String) {
        print("data2:\(data)")
        
        for (_, value) in self.procSeatArray.enumerate() {
            value.isSelected = false
        }
        self.mainBtnViewHide()
        let content = XConnectionHelper.contentOfWanServerString(data)
        if content != nil {
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                // 向内网服务器发送推送成功的消息
                self.pushSignStatusToLanServer()
            }
        }
    }
    
    func postTextFail(data: String) {
        
    }
    
    func pushSignStatusToLanServer() {
        self.hud.show(true)
        var parameters = Dictionary<String, String>()
        parameters["Key"] = "Time"
        parameters["QdType"] = String(SignStatus.SignStatusSubmited.rawValue)
        let users = NSMutableString()
        for i in 0..<self.procSeatArray.count {
            let seatInfo = self.procSeatArray[i]
            if self.isLastOPAtAM {
                if i < self.procSeatArray.count - 1 {                    
                    users.appendString(seatInfo.userInfo!.userID + "," + seatInfo.userInfo!.userName + "," + String(seatInfo.amSignStatus.rawValue + 3) + "#")
                }else {
                    users.appendString(seatInfo.userInfo!.userID + "," + seatInfo.userInfo!.userName + "," + String(seatInfo.amSignStatus.rawValue + 3))
                }
            }else {
                if i < self.procSeatArray.count - 1 {
                    users.appendString(seatInfo.userInfo!.userID + "," + seatInfo.userInfo!.userName + "," + String(seatInfo.pmSignStatus.rawValue + 3) + "#")
                }else {
                    users.appendString(seatInfo.userInfo!.userID + "," + seatInfo.userInfo!.userName + "," + String(seatInfo.pmSignStatus.rawValue + 3))
            }
            
            }
        }
        
        parameters["Users"] = users as String
        self.lastOP = "OPERATION_PUSH"
        let urlStr = Definition.lanSignInURL(withDomain: ApplicationCenter.defaultCenter().lanDomain)
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: parameters, filePath: nil, progress: nil, success: self.postSignSuc, cancel: {}, failure: self.postSignFail)
        
        
    }

    
    func makeEnquiriesBtn() {
        temp = "right"
        let sto = UIStoryboard(name: "Main", bundle: nil)
        let calendarViewCon = sto.instantiateViewControllerWithIdentifier("calendar")
        
        calendarViewCon.transitioningDelegate = self
        
        calendarViewCon.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.navigationController?.presentViewController(calendarViewCon, animated: true, completion: nil)
        
    }
    
    func popPrecious() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func pushSelfInfo() {
        let sto = UIStoryboard(name: "Menu", bundle: nil)
        let calendarViewCon = sto.instantiateViewControllerWithIdentifier("selfInfo")
        self.navigationController?.pushViewController(calendarViewCon, animated: true)
    }
    
    func pushAboutSelf() {
        let sto = UIStoryboard(name: "Menu", bundle: nil)
        let calendarViewCon = sto.instantiateViewControllerWithIdentifier("aboutSelf")
        self.navigationController?.pushViewController(calendarViewCon, animated: true)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if temp == "left" {
            animatedTransition.presenting = true
            
            return animatedTransition
        }
        return TopAnimator()

    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if temp == "left" {
            animatedTransition.presenting = false
            
            return animatedTransition
        }
        
        
       return TopDisAnimator()
    }
    
    
    @IBAction func curbClick(sender: AnyObject) {
        
    }
    
    func mainBtnViewShow() {
        let h = UIScreen.mainScreen().bounds.height
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.tipsView.frame = CGRectMake(0, h , self.tipsView.bounds.size.width, self.tipsView.bounds.size.height)
        }) { (true) in
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainBtnView.frame = CGRectMake(0,h - self.mainBtnView.frame.height , self.mainBtnView.bounds.size.width, self.mainBtnView.bounds.size.height)
            }) { (true) in
                print(self.tipsView.frame)
                print(self.mainBtnView.frame)

            }
            
        }//C37HM42BDTC0
        
    }
    
    func mainBtnViewHide() {
        let h = UIScreen.mainScreen().bounds.height
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.mainBtnView.frame = CGRectMake(0, h , self.mainBtnView.bounds.size.width, self.mainBtnView.bounds.size.height)
        }) { (true) in
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tipsView.frame = CGRectMake(0, h - self.tipsView.frame.height , self.tipsView.bounds.size.width, self.tipsView.bounds.size.height)
            }) { (true) in
                print(self.tipsView.frame)
                print(self.mainBtnView.frame)
            }
        }
        
    }
    
    
    func openCompletelyAnimated(animated: Bool) {
        temp = "left"
        self.presentLeftViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

