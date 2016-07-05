//
//  XDeviceHelper.swift
//  GZKT
//
//  Created by 陈 锡峻 on 15/10/14.
//  Copyright © 2015年 陈 锡峻. All rights reserved.
//

import UIKit
import Foundation

enum XDeviceType {
    case iPhone4S
    case iPhone5S
    case iPhone6S
    case iPhone6SP
    case Unknown
}

class XDeviceHelper: NSObject {
    // 获取设备的系统版本
    class func sysVersion() -> Double? {
        let version = UIDevice.currentDevice().systemVersion
        
        return Double(version)
    }
    
    // 获取设备屏幕大小，总是以垂直放置为计算方向
    class func appSize() -> CGSize {
        let boundSize = UIScreen.mainScreen().bounds.size
        
        return CGSizeMake(min(boundSize.width, boundSize.height), max(boundSize.width, boundSize.height))
    }
    
    // 获取设置类型
    class func deviceType() -> XDeviceType {
        let size = appSize()
        if size.width == 320 {
            if size.height == 480 {
                return .iPhone4S
            } else if size.height == 568 {
                return .iPhone5S
            } else {
                return .Unknown
            }
        } else if size.width == 375 {
            return .iPhone6S
        } else if size.width == 414 {
            return .iPhone6SP
        } else {
            return .Unknown
        }
    }
    
    static let isSimulator: Bool = {
        var isSim = false
#if (arch(i386) || arch(x86_64))
        isSim = true
#endif
        return isSim
    } ()
}
