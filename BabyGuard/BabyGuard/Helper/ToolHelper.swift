//
//  ToolHelper.swift
//  BabyGuard
//
//  Created by csh on 16/7/8.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ToolHelper: NSObject {

    class func isNowAM() -> Bool{
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "HH"
        let convertedDate = dateFormatter.stringFromDate(now)
        if NSInteger(convertedDate) >= 17 {
            print(">12am")
            return false
        }else {
            print("<12am")
            return true
        }
        
    }
    
    class func cacheInfoSet(key: String,value: [String]) {
        let ud = NSUserDefaults()
        ud.setValue(value, forKey: key)
        
    }
    class func cacheInfoGet(key: String) -> [String] {
        let ud = NSUserDefaults()
        let temp = ud.objectForKey(key) as! [String]
        return temp
        
    }
    
    
    
}
