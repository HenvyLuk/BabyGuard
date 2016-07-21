//
//  LoginViewController.swift
//  BabyGuard
//
//  Created by csh on 16/7/5.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var tipsLabel: UILabel!
    var curReqID = NSNumber()
    var guid = String()
    var serviceArray = [Information]()
    var areaArray: [NSDictionary] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.text = "ceshilhw"
        //self.username.text = "teacher3"

        self.password.text = "123"
        
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
        
        let userInfoDic = XKeychainHelper.loadDataForKey(Definition.KEY_KC_PREFIX + self.username.text!) as? NSDictionary
        if (userInfoDic != nil) {
            let guid = userInfoDic![Definition.KEY_KC_GUID] as? String
            if guid != nil {
                self.guid = guid!
            }else{
                self.guid = ""
            }
        }else {
           self.guid = ""
        }
        
        
        
        
        
        let urlString = Definition.listDomain()
        RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.listDomainSuc, cancel: {}, failure: self.listDomainFail)
        
        ApplicationCenter.defaultCenter().wanDomain = "wx.gztn.com.cn"
        
        // Do any additional setup after loading the view.
    }

    func listDomainSuc(data: String) {
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
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
        }
    }
    
    func listDomainFail(data: String) {
        
    }
    
    
    

    @IBAction func loginBtnAction(sender: AnyObject) {
        if let userName = self.username.text {
            if userName == "" {
                tipsLabel.text = "请输入用户名"
                tipsLabel.hidden = false
                return
            }
        } else {
            tipsLabel.text = "请输入用户名"
            tipsLabel.hidden = false
            return
        }
        
        if let password = self.password.text {
            if password == "" {
                tipsLabel.text = "请输入密码"
                tipsLabel.hidden = false
                return
            }
        } else {
            tipsLabel.text = "请输入密码"
            tipsLabel.hidden = false
            return
        }
    

        
        var parameters = [NSObject : AnyObject]()
        //parameters["CheckID"] = Definition.PARA_CHECK_ID
        parameters["Para1"] = ApplicationCenter.defaultCenter().clientID
        parameters["Para2"] = self.username.text!
        parameters["Para3"] = self.password.text!


        
        var loginStr = ""
        
        if Platform.isSimulator {
//            loginStr = Definition.loginUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: self.username.text!, passWord: self.password.text!, phoneSerial: ApplicationCenter.defaultCenter().udid!, verifyID: self.guid)
             loginStr = Definition.loginUrlGT(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: self.username.text!, passWord: self.password.text!, GTSerial: ApplicationCenter.defaultCenter().udid!, verifyID: self.guid)
            print("loginStr:\(loginStr)")
            
        }else {
            if ApplicationCenter.defaultCenter().udid == nil {
               loginStr = Definition.loginUrlGT(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: self.username.text!, passWord: self.password.text!, GTSerial: "NotGotClientID", verifyID: self.guid)
            }else {
               loginStr = Definition.loginUrlGT(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userName: self.username.text!, passWord: self.password.text!, GTSerial: ApplicationCenter.defaultCenter().udid!, verifyID: self.guid)
            }
            
            
        }
        
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: loginStr, parameters: nil, filePath: nil, progress: nil, success: self.loginGotSucResponse, cancel: {}, failure: self.loginGotFailResponse)
       
        
        
    }
    
    func loginGotSucResponse(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        
        if (content != nil) {
            print("userInfo:\(content)")
            if ((content[Definition.KEY_SER_SUC]?.isEqual("true")) != nil) {
                if let dataDic = content[Definition.KEY_SER_DATA] as? NSDictionary{

                    let userInfo = UserInfo.userInfoFromServerData(dataDic)
                    ApplicationCenter.defaultCenter().curUser = userInfo
                    
                    //print("dataDic:\(dataDic)")
                    
                    // 保存用户信息
                    let guid = dataDic[Definition.KEY_DATA_GUID] as! String
                    
                    let userInfoDic: Dictionary<String, String> = [Definition.KEY_KC_PASSWORD: self.password.text!, Definition.KEY_KC_GUID: guid
                        ,Definition.KEY_KC_DOMAIN: ApplicationCenter.defaultCenter().wanDomain!]
                    
                    XKeychainHelper.saveData(userInfoDic, forKey: Definition.KEY_KC_PREFIX + self.username.text!)
            
                    
                    
                    
                    
                    
                    let urlString = Definition.listSchoolServers(withDomain: ApplicationCenter.defaultCenter().wanDomain!, userID: dataDic[Definition.KEY_DATA_ID] as! String, schoolID: dataDic[Definition.KEY_SER_DEPT_SCHID] as! String)
                    RequestCenter.defaultCenter().getHttpRequest(withUtl: urlString, success: self.listSchoolServerSuc, cancel: {}, failure: self.listSchoolServerFail)
                    
                    
                    
                    
                    
                    
                    
                    
                    let listViewCon = ListViewController()
                    self.navigationController?.pushViewController(listViewCon, animated: true)
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    func loginGotFailResponse(data: String) {
       
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
                    
                  

                }
                
                
            }
            
            
            
            
        }
        
    }
    
    func listSchoolServerFail(data: String) {
        
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
