//
//  FadeOutFadeInAnimator.swift
//  Mvvm
//
//  Created by Sagepath on 2/12/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

class SplashFadeAnimator : NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    
    let splashDuration = 0.180
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.350
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) as! SplashViewController
        let toVC = transitionContext.viewController(forKey: .to)!
     
        transitionContext.containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: splashDuration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            fromVC.splash.alpha = 0.0
        }) { (didComplete) -> Void in
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            fromVC.background.alpha = 0.0
        }) { (didComplete) -> Void in
            transitionContext.completeTransition(didComplete)
        }
        
    }
}
