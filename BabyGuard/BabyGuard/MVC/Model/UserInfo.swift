//
//  UserInfo.swift
//  BabyGuard
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class UserInfo: Information {

    var userID = ""
    var personName = ""
    var userName = ""
    var password = ""
    var loginLevel = ""
    var isChatEnable = Bool()
    var isManualSign = Bool()
    var userLevel: UserLevel?

//    init(userName un: String,passWord pw:String) {
//        super.init()
//        name = un
//        password = pw
//    }
    
    class func userInfoFromServerData(dataDic :NSDictionary, withUserName un: String, withPassword pw :String) -> UserInfo {
        
        let userInfo = UserInfo()
        
        userInfo.userID = dataDic["_id"] as! String
        userInfo.personName = dataDic["PersonName"] as! String
        
        let signCode = dataDic["Phone"] as? String
        userInfo.isManualSign = (signCode == "1") ? true : false
        let studentCode = dataDic["StudentCode"] as? String
        userInfo.isChatEnable = (studentCode == "1") ? true : false
        
        userInfo.loginLevel = dataDic["LoginLevel"] as! String
        userInfo.userLevel = dataDic["YXBZ"] as? UserLevel
    
        
        return userInfo
    }
    
}
