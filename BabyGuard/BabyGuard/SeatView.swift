//
//  SeatView.swift
//  BabyGuard
//
//  Created by csh on 16/6/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class SeatView: TapableView {
    
    var cirImgView = UIImageView()
    var nameLabel = UILabel()
    var amCircleView = CircleView()
    var pmCircleView = CircleView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cirImgView.backgroundColor = UIColor.clearColor()
        self.cirImgView = UIImageView.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.width))
        self.cirImgView.image = UIImage.init(named: "dotted_line_circle")
        self.addSubview(self.cirImgView)
        
        self.nameLabel.backgroundColor = UIColor.clearColor()
        self.nameLabel = UILabel.init(frame: CGRectMake(0, 64, frame.size.width, 17))
        self.nameLabel.font = UIFont.boldSystemFontOfSize(14)
        self.nameLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(self.nameLabel)
        
        self.amCircleView = CircleView.init(frame: CGRectMake(2, 2, frame.size.width - 4, frame.size.width - 4))
        self.amCircleView.isUpper = true
        self.amCircleView.radius = (frame.size.width - 4) * 0.5
        self.addSubview(self.amCircleView)
        
        self.pmCircleView = CircleView.init(frame: CGRectMake(2, 2, frame.size.width - 4, frame.size.width - 4))
        self.pmCircleView.isUpper = false
        self.pmCircleView.radius = (frame.size.width - 4) * 0.5
        self.addSubview(self.pmCircleView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    func showSeatInformation(seatInfo: SeatInfo) {
    
        if (seatInfo.isSelected == true) {
            self.cirImgView.hidden = false
        }else {
            self.cirImgView.hidden = true
        }
        self.nameLabel.text = seatInfo.userInfo?.personName
        
        switch seatInfo.amSignStatus {
        case .SignStatusNo:
            self.amCircleView.color = UIColor(red: 0.62, green: 0.89, blue: 1.0, alpha: 1)
        case .SignStatusIll:
            self.amCircleView.color = UIColor.redColor()
        case .SignStatusManual:
            self.amCircleView.color = UIColor(red: 0.32, green: 0.92, blue: 0.72, alpha: 1)
        case .SignStatusCard:
            self.amCircleView.color = UIColor(red: 0.94, green: 0.86, blue: 0.38, alpha: 1)
        case .SignStatusCPushed,.SignStatusMPushed:
            self.amCircleView.color = UIColor(red: 0.23, green: 0.67, blue: 0.53, alpha: 1)
        default:
            break
        }

        switch seatInfo.pmSignStatus {
        case .SignStatusNo:
            self.pmCircleView.color = UIColor(red: 0.62, green: 0.89, blue: 1.0, alpha: 1)
        case .SignStatusIll:
            self.pmCircleView.color = UIColor.redColor()
        case .SignStatusManual:
            self.pmCircleView.color = UIColor(red: 0.32, green: 0.92, blue: 0.72, alpha: 1)
        case .SignStatusCard:
            self.pmCircleView.color = UIColor(red: 0.94, green: 0.86, blue: 0.38, alpha: 1)
        case .SignStatusCPushed,.SignStatusMPushed:
            self.pmCircleView.color = UIColor(red: 0.23, green: 0.67, blue: 0.53, alpha: 1)
        default:
            break
        }
        
        self.amCircleView.setNeedsDisplay()
        self.pmCircleView.setNeedsDisplay()
    }
    
    
    
    
    
    
    
    
    
    
    
    

}
