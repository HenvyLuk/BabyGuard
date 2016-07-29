//
//  SeatInfo.swift
//  BabyGuard
//
//  Created by csh on 16/7/7.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class SeatInfo: NSObject {

    var userInfo: UserInfo?
    var amSignStatus = SignStatus.SignStatusNo
    var pmSignStatus = SignStatus.SignStatusNo
    var amSignTime = ""
    var pmSignTime = ""
    var isSelected = Bool?()
    
    
    class func seatInfoFromServerData(dataDic: NSDictionary) -> SeatInfo {
    
        let userInfo = UserInfo()
        userInfo.userID = dataDic["_id"] as! String
        userInfo.personName = dataDic["PersonName"] as! String
        
        let seatInfo = SeatInfo()
        seatInfo.userInfo = userInfo
        seatInfo.isSelected = false
        seatInfo.amSignStatus = .SignStatusNo
        seatInfo.pmSignStatus = .SignStatusNo
        
        return seatInfo
        
    
    }
    
    
}
