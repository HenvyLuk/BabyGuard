//
//  DataHelper.swift
//  BabyGuard
//
//  Created by csh on 16/7/5.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit
import AssetsLibrary

class DataHelper: NSObject {

    class func contentOfServerDataString(dataStr: String) -> NSDictionary? {
        do {
            if let datas = dataStr.dataUsingEncoding(NSUTF8StringEncoding) {
                let content = try NSJSONSerialization.JSONObjectWithData(datas, options: .MutableLeaves)
                print("content:\(content)")
                return content as? NSDictionary
            } else {
                return nil
            }
        } catch {
            print("content error")
        }
        
        return nil
    }
    
    
    class func analyzeServerData(inString dataStr: String) -> (isSuc: Bool, error: String?, count: Int, datas: AnyObject?, attribute: AnyObject?) {
        if let content = contentOfServerDataString(dataStr) {
            let suc = content.objectForKey("Success")
            let errorInfo = content.objectForKey("ErrorInfo")
            let maxCount = content.objectForKey("MaxCount")
            let data = content.objectForKey("SerData")
            let attribute = content.objectForKey("AttachValue")
            
            if (suc as! String) == "true" {
                let count = Int(maxCount as! String)
                
                return (true, nil, count!, data, attribute)
            } else {
                return (false, errorInfo as? String, 0, nil, nil)
            }
        }
        
        print("服务器返回不能解析的数据:" + dataStr)
        return (false, "数据解析失败", 0, nil, nil)
    }
    
    
}
