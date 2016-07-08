//
//  ApplicationCenter.swift
//  BabyGuard
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ApplicationCenter: NSObject {

    var wanDomain = String?()
    
    var lanDomain = ""
    
    var clientID = String?()
    
    var curUser = UserInfo?()
    
    var curClass = ClassInfo?()
    
    var curSchool = SchoolInfo?()
    
    var appDirector = DataDirector.directorInApp()
    
    class func defaultCenter() -> ApplicationCenter {
        struct singleton {
            static var onceToken: dispatch_once_t = 0
            static var instance: ApplicationCenter? = nil
        }
        dispatch_once(&singleton.onceToken,{
            singleton.instance = ApplicationCenter()
        })
        return singleton.instance!
    }
    
}
