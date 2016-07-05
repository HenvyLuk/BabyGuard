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
        //self.nameLabel.font = UIFont(name: "iconfont", size: 14)
        self.nameLabel.font = UIFont.boldSystemFontOfSize(14)
        self.nameLabel.textAlignment = NSTextAlignment.Center
        self.nameLabel.text = "1111"
        self.addSubview(self.nameLabel)
        
        self.amCircleView = CircleView.init(frame: CGRectMake(2, 2, frame.size.width - 4, frame.size.width - 4))
        self.amCircleView.isUpper = true
        self.amCircleView.radius = frame.size.width - 4
        self.addSubview(self.amCircleView)
        
        self.pmCircleView = CircleView.init(frame: CGRectMake(2, 2, frame.size.width - 4, frame.size.width - 4))
        self.pmCircleView.isUpper = false
        self.pmCircleView.radius = frame.size.width - 4
        self.addSubview(self.pmCircleView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    


}
