//
//  TopDisAnimator.swift
//  BabyGuard
//
//  Created by csh on 16/7/12.
//  Copyright © 2016年 csh. All rights reserved.
//

import UIKit
import Foundation

class TopDisAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    internal func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
        
    }
    
    internal func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = (transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey))! as UIViewController
        toVC.view.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        toVC.view.userInteractionEnabled = true
        
        let fromVC = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey))! as UIViewController

        
        let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        opacityAnimation.toValue = 0
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        let offscreenAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        offscreenAnimation.toValue = -screenHeight * 0.5
        //fromVC.view.layer.pop_addAnimation(offscreenAnimation, forKey: "offscreenAnimation")
        

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            fromVC.view.transform = CGAffineTransformMakeTranslation(0, -screenHeight)
            
        }) { (true) in
            transitionContext.completeTransition(true)
            
        }
  
        
    }
    
}
