//
//  SchoolInfo.swift
//  BabyGuard
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class SchoolInfo: Information {
    
    func schoolInfoFromServerData(dataDic :NSDictionary) -> SchoolInfo {
        
        let schoolInfo = SchoolInfo?()
        
        schoolInfo?.identifier = dataDic["_id"] as! String
        schoolInfo?.name = dataDic["DeptName"] as! String
        
        return schoolInfo!
    }
    
}
