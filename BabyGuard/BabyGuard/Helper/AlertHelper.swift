//
//  AlertHelper.swift
//  BabyGuard
//
//  Created by csh on 16/7/18.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {

    class func showConfirmAlert(message: String, delegate: UIAlertViewDelegate?, type: Int) {
        let alertView = UIAlertView(title: "", message: message, delegate: delegate, cancelButtonTitle: "确定")
        alertView.tag = type
        alertView.show()

    }
    
    class func showOptionAlert(message: String, delegate: UIAlertViewDelegate?, type: Int) {
        let alertView = UIAlertView(title: "", message: message, delegate: delegate, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        alertView.tag = type
        alertView.show()
    }
    
    class func showAlertDismiss(message: String, delegate: UIAlertViewDelegate?) {
        let alertView = UIAlertView(title: "提示", message: message, delegate: delegate, cancelButtonTitle: "确定")
        alertView.show()
        self.performSelector(#selector(AlertHelper.dissmiss), withObject: alertView, afterDelay: 1.0)
        
    }

    func dissmiss(withAlertView alertView: UIAlertView) {
        print("dddddddd")
        alertView.dismissWithClickedButtonIndex(0, animated: true)
        
        
    }
}
