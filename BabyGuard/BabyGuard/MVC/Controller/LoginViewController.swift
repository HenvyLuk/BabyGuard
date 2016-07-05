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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.text = "ceshilhw"
        self.password.text = "123"
        
        // Do any additional setup after loading the view.
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
        //wx.gztn.com.cn
        //SJGZ-GZTN-CXJ-2013
        //#define URL_LOGIN_GT            @"http://%@/nopage/GTPhoneLogin/?CheckID=SJGZ-GZTN-CXJ-2013&UserName=%@&Pwd=%@&GTSerial=%@&VerifyID=%@"
        //#define URL_LIST_DOMAIN         @"http://wx.gztn.com.cn/nopage/ALL_HOST_LIST"

        tipsLabel.hidden = true
        
        var parameters = [NSObject : AnyObject]()
        //parameters["CheckID"] = Definition.PARA_CHECK_ID
        parameters["Para1"] = ApplicationCenter.defaultCenter().clientID
        parameters["Para2"] = self.username.text!
        parameters["Para3"] = self.password.text!
        
        let loginStr = Definition.loginUrl(withDomain: "wx.gztn.com.cn", userName: self.username.text!, passWord: self.password.text!, phoneSerial: "NotGotClientID", verifyID: self.guid)
        print("loginStr:\(loginStr)")
        
        RequestCenter.defaultCenter().postHttpRequest(withUrl: loginStr, parameters: nil, filePath: nil, progress: nil, success: self.loginGotSucResponse, cancel: {}, failure: self.loginGotFailResponse)
        
        
    }
    
    func loginGotSucResponse(data: String) {
        let content = XConnectionHelper.contentOfWanServerString(data)
        
        if (content != nil) {
            print("content\(content)")
            if ((content["Success"]?.isEqual("true")) != nil) {
                if let dataDic = content["SerData"] as? NSDictionary{
                    
                    let userInfo = UserInfo.userInfoFromServerData(dataDic, withUserName: self.username.text!, withPassword: self.password.text!)
                    ApplicationCenter.defaultCenter().curUser = userInfo
                    
                    // 保存用户信息
                    
                 
                    let seatViewCon = SeatTableViewController()
                    self.navigationController?.pushViewController(seatViewCon, animated: true)
                    
                }
                
                
                
            }
            
            
        }
        
        //let content = DataHelper.analyzeServerData(inString: data)
//        if content.isSuc {
//            if let dataDic = content.datas as? NSDictionary{
//                let userInfo = UserInfo.userInfoFromServerData(dataDic, withUserName: self.username.text!, withPassword: self.password.text!)
//                
//                ApplicationCenter.defaultCenter().curUser = userInfo
//                // 保存用户信息
//                
//                
//                
//                
//                let seatViewCon = SeatTableViewController()
//                
//                self.navigationController?.pushViewController(seatViewCon, animated: true)
//            }
//        }
        
        
        
        
    }
    func loginGotFailResponse(data: String) {
       
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
