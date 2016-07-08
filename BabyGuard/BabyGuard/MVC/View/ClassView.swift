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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bgImgView.backgroundColor = UIColor.clearColor()
        self.bgImgView = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.bgImgView.image = UIImage.init(named: "classBg")
        self.addSubview(self.bgImgView)
        
        self.className.backgroundColor = UIColor.clearColor()
        self.className = UILabel.init(frame: CGRectMake(0, (bgImgView.frame.size.height - 25) * 0.5, frame.size.width, 25))
        self.className.font = UIFont.boldSystemFontOfSize(17)
        self.className.textAlignment = NSTextAlignment.Center
        //self.className.text = "01班级"
        self.addSubview(self.className)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 

}
