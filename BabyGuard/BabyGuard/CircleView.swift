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
    var color = UIColor.greenColor()
    var isUpper = Bool()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
//        CGContextSetAllowsAntialiasing(context, true)
//        
//        CGContextSetStrokeColorWithColor(context, self.color.CGColor)
//        CGContextAddArc(context,self.radius,self.radius,self.radius,0,CGFloat(PI),(self.isUpper ? 1 : 0))
//        
//        //CGContextAddEllipseInRect(context, CGRectMake(5,5,100,100))
//        CGContextStrokePath(context)
        

        
        CGContextSetFillColorWithColor(context, self.color.CGColor)
        CGContextMoveToPoint(context,self.radius,self.radius)
        CGContextAddArc(context,self.radius,self.radius,self.radius,0,CGFloat(PI),(self.isUpper ? 1 : 0))
        CGContextFillPath(context)
        
    }
 

}
