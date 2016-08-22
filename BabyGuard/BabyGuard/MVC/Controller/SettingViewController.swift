//
//  SettingViewController.swift
//  BabyGuard
//
//  Created by csh on 16/8/1.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIAlertViewDelegate {
    @IBOutlet weak var oldSecrets: UITextField!
    @IBOutlet weak var makeSureNews: UITextField!
    @IBOutlet weak var newSecrets: UITextField!
    
    @IBOutlet weak var tipsLabel: UILabel!
    var hud = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()

        tipsLabel.hidden = true
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func updateClick(sender: AnyObject) {
        if oldSecrets.isFirstResponder() {
            oldSecrets.resignFirstResponder()
        }
        if newSecrets.isFirstResponder() {
            newSecrets.resignFirstResponder()
        }
        if makeSureNews.isFirstResponder() {
            makeSureNews.resignFirstResponder()
        }
        if oldSecrets.text == "" {
            tipsLabel.text = "请输入旧密码"
            tipsLabel.hidden = false
            return
        }
        if newSecrets.text == "" {
            tipsLabel.text = "请输入新密码"
            tipsLabel.hidden = false
            return
        }
        if makeSureNews.text == "" {
            tipsLabel.text = "请再次输入新密码"
            tipsLabel.hidden = false
            return
        }
        
        let string = self.newSecrets.text
        for char in string!.utf8 {
            if (char > 64 && char < 91) || (char > 96 && char < 123) || (char > 47 && char < 58) {
                
            }else {
                tipsLabel.text = "请使用数字和大小写字母创建密码"
                tipsLabel.hidden = false
                return
            }
        }
        if newSecrets.text != makeSureNews.text {
            tipsLabel.text = "两次输入的新密码不相同"
            tipsLabel.hidden = false
            return
        }
        
        var parameters = Dictionary<String, String>()
        parameters[Definition.KEY_URL_CHECK_ID] = Definition.PART_URL_CHECK_ID
        parameters[Definition.KEY_URL_USER_ID] = ApplicationCenter.defaultCenter().curUser?.userID
        parameters[Definition.KEY_URL_POST_TYPE] = "CHANGE_PWD"
        parameters[Definition.KEY_URL_POST_STRING] = newSecrets.text
        parameters[Definition.KEY_URL_INFO] = oldSecrets.text
        
        tipsLabel.hidden = true
        hud.show(true)
        
        let urlStr = Definition.postTextUrl(withDomain: ApplicationCenter.defaultCenter().wanDomain!)
        RequestCenter.defaultCenter().postHttpRequest(withUrl: urlStr, parameters: parameters, filePath: nil, progress: nil, success: self.updateSuc, cancel: {}, failure: self.updateFail)
        
        
    }
    
    func updateSuc(data: String) {
        print("data:\(data)")
        hud.hide(true)
        let content = XConnectionHelper.contentOfWanServerString(data)
        if content != nil {
            if (content[Definition.KEY_SER_SUC] as! String == "true") {
                self.alertView(withMessage: "密码修改成功! ")
                self.performSelector(#selector(SettingViewController.dismissSet), withObject: nil, afterDelay: 2)
            
            }else if (content[Definition.KEY_SER_SUC] as! String == "false") {
                self.alertView(withMessage: content["ErrorInfo"] as! String)
            
            }
        }
        
    }
    
    func updateFail(data: String) {
        self.alertView(withMessage: "网络故障，请稍后再试！")
        self.performSelector(#selector(SettingViewController.dismissSet), withObject: nil, afterDelay: 2)

    }
    func alertView(withMessage message: String) {
        let alertView = UIAlertView(title: "提示", message: message, delegate: self, cancelButtonTitle: "确定")
        alertView.show()
        self.performSelector(#selector(SettingViewController.dissmiss), withObject: alertView, afterDelay: 1.0)
    }
    
    func dissmiss(withAlertView alertView: UIAlertView) {
        alertView.dismissWithClickedButtonIndex(0, animated: true)
        
    }
    func dismissSet()  {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {
        })
    }

    @IBAction func dismissSetting(sender: AnyObject) {
        self.dismissSet()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        AlertHelper.showAlertDismiss("密码修改成功! ", delegate: self)

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
