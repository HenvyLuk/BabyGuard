//
//  ClassView.swift
//  BabyGuard
//
//  Created by csh on 16/7/6.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

class ClassView: TapableView {

    var bgImgView = UIImageView()
    var className = UILabel()
    var bgView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bgImgView.backgroundColor = UIColor(red: 0.62, green: 0.89, blue: 1.0, alpha: 1)
        self.bgImgView = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        //self.bgImgView.image = UIImage.init(named: "classBg")
        
        self.bgView = UIView.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.bgView.backgroundColor = UIColor(red: 0.23, green: 0.67, blue: 0.53, alpha: 1)
        self.addSubview(self.bgView)
        
        self.className = UILabel.init(frame: CGRectMake(0, (bgImgView.frame.size.height - 25) * 0.5, frame.size.width, 25))
        self.className.font = UIFont.boldSystemFontOfSize(17)
        self.className.textAlignment = NSTextAlignment.Center
        self.addSubview(self.className)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 

}
