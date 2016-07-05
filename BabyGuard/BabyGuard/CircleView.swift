//
//  CircleView.swift
//  BabyGuard
//
//  Created by csh on 16/6/30.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit

let PI = 3.14159265358979323846

class CircleView: UIView {
    
    var radius = CGFloat()
    var color = UIColor()
    var isUpper = Bool()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
//    override func drawRect(rect: CGRect) {
//        let content = UIGraphicsGetCurrentContext()
//        
//        CGContextSetFillColorWithColor(content, self.color.CGColor)
//        CGContextMoveToPoint(content,self.radius,self.radius)
//        CGContextAddArc(content,self.radius,self.radius,self.radius,0,CGFloat(PI),(self.isUpper ? 1 : 0))
//        CGContextFillPath(content)
//        
//    }
 

}
