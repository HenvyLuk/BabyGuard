//
//  TopAnimator.swift
//  BabyGuard
//
//  Created by csh on 16/7/12.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit
import Foundation

class TopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

     func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
       return 0.5
    
    }
   
     func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        let fromView = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view)! as UIView
        fromView.tintAdjustmentMode = UIViewTintAdjustmentMode.Dimmed
        fromView.userInteractionEnabled = false
        
        let dimmingView = UIView(frame: fromView.bounds)
        dimmingView.layer.opacity = 0
        
        let toView = (transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view)! as UIView
        toView.frame = CGRectMake(0,
                                  0,
                                  CGRectGetWidth(transitionContext.containerView()!.bounds),
                                  CGRectGetHeight(transitionContext.containerView()!.bounds))
        
        toView.center = CGPointMake(transitionContext.containerView()!.center.x, -transitionContext.containerView()!.center.y)
        
        transitionContext.containerView()?.addSubview(dimmingView)
        transitionContext.containerView()?.addSubview(toView)
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        positionAnimation.toValue = screenHeight * 0.5 * 0.15
        positionAnimation.springBounciness = 10
        
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 20
        scaleAnimation.fromValue = NSValue.init(CGPoint: CGPointMake(1.2, 1.4))
        
        toView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
        
        //toView.layer.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
        //dimmingView.layer.pop_addAnimation(opacityAnimation, forKey: "opacityAnimation")
        
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            //toView.transform = CGAffineTransformMakeTranslation(0, screenHeight * 0.618)

            
            }) { (true) in
                transitionContext.completeTransition(true)

        }
        
        
        

        
    }
    
}
