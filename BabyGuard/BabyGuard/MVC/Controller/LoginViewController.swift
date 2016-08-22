//
//  LoginViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/5.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

typealias block = (Int)->()

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate,UIAlertViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var pwd: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var userName = ""
    var passWord = ""
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var areaPickView: UIPickerView!
    @IBOutlet weak var areaLabel: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    var curReqID = NSNumber()
    var guid = String()
    var hud = MBProgressHUD()
    var areaArray: [NSDictionary] = []
    var hostNames = [String]()
    //var isAutoLogin = Bool()
    var serviceArray = [Information]()
    var timer = NSTimer()
    var blur = FXBlurView()
    var timerInterval = CGFloat(0)
    var a = 0
    var isAutoLogin = Bool()
//1242 × 2208

    @IBOutlet weak var loginView: UIButton!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.loginView.layer.cornerRadius = 5
        self.loading.hidesWhenStopped = true
        self.loading.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.loginFailNotice), name: "loginFailNotice", object: nil)
        //self.username.text = "ceshilhw"
        //self.username.text = "teacher3"
        //self.password.text = "1234"
        
        let urlString = Definition.listDomain()
        RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.listDomainSuc, cancel: {}, failure: self.listDomainFail)
        
        self.scrollView()
        self.addTimer()
        self.myScrollView.userInteractionEnabled = false
        self.addBlurView()
        
        //NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LoginViewController.test), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.myScrollView.contentOffset.y = 100
        
        self.isAutoLogin = false
        
        if Platform.isSimulator {
            var udid = XKeychainHelper.loadDataForKey(Definition.KEY_KC_UDID) as? String
            if udid == nil {
                
                udid = XKeychainHelper.generateUDID()
                ApplicationCenter.defaultCenter().udid = udid
                XKeychainHelper.saveData(udid, forKey: Definition.KEY_KC_UDID)
                print("udid:\(udid)")
            }else {
                ApplicationCenter.defaultCenter().udid = udid
            }
        }else {
            print("do nothing")
        }
        
        let userName = XKeychainHelper.loadDataForKey(Definition.KEY_KC_LAST_NAME)
        if userName != nil {
            let userInfoDic = XKeychainHelper.loadDataForKey(Definition.KEY_KC_PREFIX + String(userName)) as? NSDictionary
            if (userInfoDic != nil) {
                print(userInfoDic)
                let guid = userInfoDic![Definition.KEY_KC_GUID] as? String
                if guid != nil {
                    self.guid = guid!
                }else{
                    self.guid = ""
                }
                
                let domain = userInfoDic![Definition.KEY_KC_DOMAIN]
                let userID = XKeychainHelper.loadDataForKey(Definition.KEY_URL_USER_ID)
                //let classID = ToolHelper.cacheInfoGet(Definition.KEY_CLASSID)
                
                ApplicationCenter.defaultCenter().wanDomain = domain as? String
                ApplicationCenter.defaultCenter().curUser?.userID = userID as! String
                //ApplicationCenter.defaultCenter().curClass?.identifier = classID
                self.isAutoLogin = true
                
                self.password.text = userInfoDic![Definition.KEY_KC_PASSWORD] as? String
                self.username.text = XKeychainHelper.loadDataForKey(Definition.KEY_KC_LAST_NAME) as? String
                if XKeychainHelper.loadDataForKey(Definition.KEY_KC_DOMAINNAME) as? String != nil {
                    self.tipsLabel.text = XKeychainHelper.loadDataForKey(Definition.KEY_KC_DOMAINNAME) as? String
                }
                
                print(domain)
                print(userID)
                print(self.username.text)
                print(self.password.text)
                
            }else {
                self.guid = ""
            }
            
        }
        
        if isAutoLogin == true {
       
            
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func test()  {
        //print("aaa")
        a += 1
        print(a,self.myScrollView.contentOffset.y)
        
    }
    
    func addBlurView()  {
        let cover = UIView.init(frame: CGRectMake(0, 0, self.view.frame.width, self.myScrollView.contentSize.height))
        cover.alpha = 0.5
        cover.backgroundColor = UIColor.blackColor()
        self.myScrollView.addSubview(cover)
        
    }
    
    func scrollView()  {
        self.myScrollView.delegate = self

        for i in 1..<3 {
            let imageViewX = CGFloat(0)
            let imageViewY = CGFloat(i - 1)  * (self.view.bounds.size.height)
            let imageViewW = self.view.bounds.size.width
            let imageViewH = self.view.bounds.size.height
            
            let myImageView = UIImageView.init(frame: CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH))
            let name = String(i)
            
            myImageView.image = UIImage(named: name)
            self.myScrollView.addSubview(myImageView)
        }
        self.myScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 2 * self.view.bounds.size.height)
        self.myScrollView.contentOffset.y = 100
    }
    
    func addTimer()  {
        let bottomOffset = CGPointMake(0, self.view.frame.size.height * 0.25 + 100)
        let scrollDurationInSeconds = CGFloat(15.0)

        let totalScrollAmount = CGFloat(bottomOffset.y)
        let timerInterval = scrollDurationInSeconds / totalScrollAmount
        self.timerInterval = timerInterval
        NSTimer.scheduledTimerWithTimeInterval(Double(timerInterval), target: self, selector: #selector(LoginViewController.cycleImage), userInfo: nil, repeats: true)
        
        //#selector(LoginViewController.cycleImage)
    }
    
    
    func cycleImage(withTimer timer: NSTimer) {
        var newScrollViewContentOffset = self.myScrollView.contentOffset
        newScrollViewContentOffset.y += 1
        self.myScrollView.contentOffset = newScrollViewContentOffset
        if (newScrollViewContentOffset.y == self.view.bounds.height * 0.25 + 100) {
            timer.invalidate()
            NSTimer.scheduledTimerWithTimeInterval(Double(timerInterval), target: self, selector: #selector(LoginViewController.backCycleImage), userInfo: nil, repeats: true)

            
        }
        
    }
    
    func backCycleImage(withTimer timer: NSTimer) {
        var newScrollViewContentOffset = self.myScrollView.contentOffset
         newScrollViewContentOffset.y -= 1
        self.myScrollView.contentOffset = newScrollViewContentOffset
        if (newScrollViewContentOffset.y == 0) {
            timer.invalidate()
            NSTimer.scheduledTimerWithTimeInterval(Double(timerInterval), target: self, selector: #selector(LoginViewController.cycleImage), userInfo: nil, repeats: true)

        }
        
    }
    
    func controlsMoving(withUp isUp: Bool) {
        let	controls = [self.areaLabel,self.tipsLabel,self.loginView,self.username,self.password]
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { 
            if isUp {
                for (_, value) in controls.enumerate() {
                    value.frame = CGRectMake(value.frame.origin.x, value.frame.origin.y - 40, value.frame.width, value.frame.height)
                }
            }else {
                for (_, value) in controls.enumerate() {
                    value.frame = CGRectMake(value.frame.origin.x, value.frame.origin.y + 40, value.frame.width, value.frame.height)
                }
            }
            }, completion: nil)
        
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("bbbbb")
        self.controlsMoving(withUp: true)

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("eeeeee")
        self.controlsMoving(withUp: false)

    }
    
    @IBAction func areaClick(sender: AnyObject) {
        self.controlsMoving(withUp: true)

        let h = UIScreen.mainScreen().bounds.height
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.toolBar.frame = CGRectMake(0, h - self.areaPickView.frame.height - 44, self.toolBar.frame.width, 44)
            print(self.areaPickView.frame.height)
            self.areaPickView.frame = CGRectMake(0, h - self.areaPickView.frame.height, self.areaPickView.frame.width, self.areaPickView.frame.height)
            
            }) { (true) in
                self.tipsLabel.text = self.hostNames[0]

                
        }
        
    }
    
    func pickViewHide() {
        self.controlsMoving(withUp: false)

        let h = UIScreen.mainScreen().bounds.height
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.blur.removeFromSuperview()
            self.toolBar.frame = CGRectMake(0, h, self.toolBar.frame.width, 44)
            self.areaPickView.frame = CGRectMake(0, h + 44, self.areaPickView.frame.width, self.areaPickView.frame.height)
        }) { (true) in
            
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //self.pickViewHide()
        if self.username.isFirstResponder() {
            self.username.resignFirstResponder()
            //self.controlsMoving(withUp: false)
            
        }
        if self.password.isFirstResponder() {
            self.password.resignFirstResponder()
            //self.controlsMoving(withUp: false)
            
        }
        
        
    }
    
    @IBAction func dismissPickerView(sender: AnyObject) {
        self.pickViewHide()
    }
    
    @IBAction func makeSureWithArea(sender: AnyObject) {
        self.pickViewHide()
        for (index, value) in self.areaArray.enumerate() {
            let name = value[Definition.KEY_DATA_HOST_NAME] as! String
            if name == self.tipsLabel.text {
                let dic = self.areaArray[index]
                ApplicationCenter.defaultCenter().wanDomain = dic[Definition.KEY_DATA_HOST_DOMAIN] as? String
                XKeychainHelper.saveData(name, forKey: Definition.KEY_KC_DOMAINNAME)
                
            }
            
        }

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return self.hostNames.count
    }
    
   func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.hostNames[row]
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
       return 30
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIView.animateWithDuration(0.2) { 
            self.tipsLabel.text = self.hostNames[row]

        }
        
        
    }
    
    func listDomainSuc(data: String) {
        hud.show(true)
        let content = XConnectionHelper.contentOfWanServerString(data)
        if (content != nil) {
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                let count = content[Definition.KEY_SER_COUNT] as? String
                if NSInteger(count!) > 0 {
                    let dataArray = content[Definition.KEY_SER_DATA] as? NSArray
                    for (_,value) in (dataArray?.enumerate())! {
                        let hostname = value[Definition.KEY_DATA_HOST_NAME] as! String
                        let hostDomain = value[Definition.KEY_DATA_HOST_DOMAIN] as! String
                        let hostDic: Dictionary<String, String> = [Definition.KEY_DATA_HOST_NAME: hostname,Definition.KEY_DATA_HOST_DOMAIN: hostDomain]
                        self.areaArray.append(hostDic)
                        self.hostNames.append(hostname)
                    
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hud.hide(true)
                        self.areaPickView.reloadAllComponents()
                    })
                    
                }
                
                
            }
            
        }
    }
    
    func listDomainFail(data: String) {
        
    }
    
    func login(withUsername userName: String, passWord: String) {
            if userName == "" {
                AlertHelper.showConfirmAlert("请输入用户名", delegate: nil, type: 0)
                return
            }
        
            if passWord == "" {
                AlertHelper.showConfirmAlert("请输入密码", delegate: nil, type: 0)
                return
            }
        if (self.tipsLabel.text == "请选择区域") {
            AlertHelper.showConfirmAlert("请先选择区域", delegate: nil, type: 0)
            return
        }
        
        var parameters = [NSObject : AnyObject]()
        //parameters["CheckID"] = Definition.PARA_CHECK_ID
        parameters["Para1"] = ApplicationCenter.defaultCenter().clientID
        parameters["Para2"] = userName
        parameters["Para3"] = passWord
        
        
        var loginStr = ""
        
        if Platform.isSimulator {
            //            loginStr = Definition.loginUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: self.username.text!, passWord: self.password.text!, phoneSerial: ApplicationCenter.defaultCenter().udid!, verifyID: self.guid)
            loginStr = Definition.loginUrlGT(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: userName, passWord: passWord, GTSerial: ApplicationCenter.defaultCenter().udid!, verifyID: self.guid)
            print("loginStr:\(loginStr)")
            
        }else {
            if ApplicationCenter.defaultCenter().udid == nil {
                loginStr = Definition.loginUrlGT(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: userName, passWord: passWord, GTSerial: "NotGotClientID", verifyID: self.guid)
            }else {
                loginStr = Definition.loginUrlGT(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: userName, passWord: passWord, GTSerial: ApplicationCenter.defaultCenter().udid!, verifyID: self.guid)
            }
            
            
        }

        RequestCenter.defaultCenter().postHttpRequest(withUrl: loginStr, parameters: nil, filePath: nil, progress: nil, success: self.loginGotSucResponse, cancel: {}, failure: self.loginGotFailResponse)
    }
 
    @IBAction func loginBtnAction() {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.login(withUsername: self.username.text!, passWord: self.password.text!)

        //})
        
    }

    func loginGotSucResponse(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        if (content != nil) {
            print("userInfo:\(content)")
            if (content[Definition.KEY_SER_SUC] as! String == "true") {
                if let dataDic = content[Definition.KEY_SER_DATA] as? NSDictionary{
                    let userInfo = UserInfo.userInfoFromServerData(dataDic)
                    ApplicationCenter.defaultCenter().curUser = userInfo
                    // 保存用户信息
                    let guid = dataDic[Definition.KEY_DATA_GUID] as! String
                    let userInfoDic: Dictionary<String, String> = [Definition.KEY_KC_PASSWORD: self.password.text!, Definition.KEY_KC_GUID: guid
                        ,Definition.KEY_KC_DOMAIN: ApplicationCenter.defaultCenter().wanDomain!]
                    
                    XKeychainHelper.saveData(userInfoDic, forKey: Definition.KEY_KC_PREFIX + self.username.text!)
                    XKeychainHelper.saveData(self.username.text, forKey: Definition.KEY_KC_LAST_NAME)
                    XKeychainHelper.saveData(userInfo.userID, forKey: Definition.KEY_URL_USER_ID)
                    
                    //XKeychainHelper.saveData(userInfo, forKey: Definition.KEY_KC_CURUSERINFO)
                    
                    
                    let urlString = Definition.listSchoolServers(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userID: dataDic[Definition.KEY_DATA_ID] as! String, schoolID: dataDic[Definition.KEY_SER_DEPT_SCHID] as! String)
                    
                    RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.listSchoolServerSuc, cancel: {}, failure: self.listSchoolServerFail)

                    self.loading.hidden = false
                    self.loading.startAnimating()
                    self.loginView.userInteractionEnabled = false
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        self.loading.stopAnimating()
                        self.loading.hidden = true
                        self.loginView.userInteractionEnabled = true
                        let listViewCon = ListViewController()
                        self.navigationController?.pushViewController(listViewCon, animated: true)
                    }
                }
            }else {
                self.loading.hidden = false
                self.loading.startAnimating()
                self.loginView.userInteractionEnabled = false
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         
                    self.loading.stopAnimating()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loginFailNotice()

                        dispatch_async(dispatch_get_main_queue(), {
                            self.loginFailNotice()
                            
                        })
                    })
                    
                }
                
            }
            
        }
        
    }
    
    func loginFailNotice() {
        let positionAnimation = POPSpringAnimation(propertyNamed: "positionX")
        positionAnimation.velocity = 10000
        positionAnimation.springBounciness = 20
        self.loginView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
        self.loading.hidden = true
        self.loginView.userInteractionEnabled = true
        print("a")

    }

    func listSchoolServerSuc(data: String) {
        
        let content = XConnectionHelper.contentOfWanServerString(data)
        if (content != nil) {
            print("SchoolServerInfo:\(content)")
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                
                
                if let dataArray = content[Definition.KEY_SER_DATA] as? NSArray {
                    var urlStr = [String]()
                    for (_,value) in dataArray.enumerate() {
                        let schSerInfo = Information()
                        schSerInfo.name = value[Definition.KEY_DATA_SER_NAME] as! String
                        schSerInfo.identifier = value[Definition.KEY_DATA_SER_URL] as! String
                        self.serviceArray.append(schSerInfo)
                        
                        urlStr.append(value[Definition.KEY_DATA_SER_URL] as! String)
                        
                        
                    }
                    
                    ToolHelper.cacheInfoSet(Definition.KEY_SERVICEURL, value: urlStr[0])
                    ApplicationCenter.defaultCenter().lanDomain = urlStr[0]
                    
                    
                }
                
                
            }
            
            
            
            
        }
        
    }
    
    func listSchoolServerFail(data: String) {
        
    }
    
    func loginGotFailResponse(data: String) {
       
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    deinit {
    
        print("login deinit")
        
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
