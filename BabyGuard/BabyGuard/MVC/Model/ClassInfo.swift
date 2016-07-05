//
//  ClassInfo.swift
//  BabyGuard
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ClassInfo: Information {

   class func classInfoFromServerData(dataDic :NSDictionary) -> ClassInfo {
        
        let classInfo = ClassInfo?()
        
        classInfo?.identifier = dataDic["_id"] as! String
        classInfo?.name = dataDic["DeptName"] as! String
        
        return classInfo!
    }
    
}
