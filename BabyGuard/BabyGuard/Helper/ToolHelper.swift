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
        if NSInteger(convertedDate) >= 12 {
            return false
        }else {
            return true
        }
        
    }
    
    class func currentDate(isFull: Bool, dayStr: String?) -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        if isFull {
            dateFormatter.dateFormat = "yyyyMMdd"
            let convertedDate = dateFormatter.stringFromDate(date)
            return convertedDate
        }else {
            dateFormatter.dateFormat = "MM.dd"
            let convertedDate = dateFormatter.stringFromDate(date)
            if dayStr == nil {
                let converted = convertedDate.stringByReplacingOccurrencesOfString("0", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                return converted
            }else {
                var converted = (dayStr! as NSString).substringFromIndex(4)
                
                let index = converted.startIndex.advancedBy(2)
                converted.insert(".", atIndex: index)
                if (converted as NSString).substringFromIndex(4) == "0" {
                    converted = converted.stringByReplacingOccurrencesOfString("0", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    converted.appendContentsOf("0")

                }else {
                    converted = converted.stringByReplacingOccurrencesOfString("0", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

                }
                
                return converted
            }
            
        }
        
        
    }
    
    class func convertDayStr(dayStr: String) {

    }
    
   class func hwcDelay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
    
    
    
    class func cacheInfoSet(key: String,value: String) {
        let ud = NSUserDefaults()
        ud.setValue(value, forKey: key)
        
    }
    class func cacheInfoGet(key: String) -> String {
        let ud = NSUserDefaults()
        let temp = ud.objectForKey(key) as! String
        return temp
        
    }
    
    class func weekDayStr(date: String) -> (String, String) {
       let comps = NSDateComponents.init()
        let now = NSDate()
        let year = (date as NSString).substringToIndex(4)
        let mon = (date as NSString).substringWithRange(NSMakeRange(4, 2))
        let day = (date as NSString).substringFromIndex(6)
        
        comps.day = NSInteger(day)!
        comps.month = NSInteger(mon)!
        comps.year = NSInteger(year)!
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierBuddhist)
        let date = gregorian?.dateFromComponents(comps)
        let weekdayComponents = gregorian?.components(NSCalendarUnit.Weekday, fromDate: date!)
        let weekday = weekdayComponents?.weekday
        print("weekday:\(weekday)")
        let calendar = NSCalendar.currentCalendar()
        
        var (firstDiff, lastDiff) = (0, 0)

        firstDiff = 1 - weekday!
        lastDiff = 7 - weekday!
        
        print(firstDiff,lastDiff)
        
        var firstDayComp = NSDateComponents.init()
        firstDayComp = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: now)
        firstDayComp.day = comps.day + firstDiff
        firstDayComp.month = comps.month
        firstDayComp.year = comps.year
        let firstDayOfWeek = calendar.dateFromComponents(firstDayComp)
        
        var lastDayComp = NSDateComponents.init()
        lastDayComp = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: now)
        lastDayComp.day = comps.day + lastDiff
        lastDayComp.month = comps.month
        lastDayComp.year  = comps.year
        let lastDayOfWeek = calendar.dateFromComponents(lastDayComp)
        
        print(firstDayOfWeek,lastDayOfWeek)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = NSLocale.currentLocale()
        let firstDay = dateFormatter.stringFromDate(firstDayOfWeek!)
        let lastDay = dateFormatter.stringFromDate(lastDayOfWeek!)
        
        return (firstDay, lastDay)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
