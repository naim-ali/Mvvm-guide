//
//  FadeOutFadeInAnimator.swift
//  Mvvm
//
//  Created by Sagepath on 2/12/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

class SlideFadeAnimator : NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationControllerOperation?
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.operation = operation
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.500
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (self.operation == UINavigationControllerOperation.push) {
            animatePush(transitionContext: transitionContext)
        } else if (self.operation == UINavigationControllerOperation.pop) {
            animatePop(transitionContext: transitionContext)
        }
    }
    
    private func animatePush(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        // move toVC off to the right of the screen
        toVC.view.center = CGPoint(x: toVC.view.center.x + toVC.view.frame.width,
                                   y: toVC.view.center.y)
        
        // set a dropshadow for toVC
        toVC.view.layer.shadowColor = Project.Colors.gray.cgColor
        toVC.view.layer.shadowRadius = 5.0
        toVC.view.layer.shadowOpacity = 0.765

        // add toVC to the container
        transitionContext.containerView.addSubview(toVC.view)
        
        // add a gray view to cover fromVC
        let overlay = UIView()
        overlay.backgroundColor = Project.Colors.gray
        overlay.alpha = 0.0
        overlay.frame = fromVC.view.frame
        fromVC.view.addSubview(overlay)
        
        // slide fromVC out to the left
        UIView.animate(withDuration: 0.350, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            fromVC.view.center = CGPoint(x: fromVC.view.center.x * 0.53125,
                                         y: fromVC.view.center.y)
        }) { (didComplete) -> Void in
        }
        
        // darken fromVC a bit
        UIView.animate(withDuration: 0.170, animations: { () -> Void in
            overlay.alpha = 0.1
        }) { (didComplete) -> Void in
        }
        
        // slide toVC in from the right
        if #available(iOS 10.0, *) {
            let timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.17, y: 0.17), controlPoint2: CGPoint(x: 0.0, y: 1.0))
            let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), timingParameters:timing)
            animator.addAnimations {
                toVC.view.center = CGPoint(x: toVC.view.center.x - toVC.view.frame.width,
                                           y: toVC.view.center.y)
            }
            animator.addCompletion({_ in
                overlay.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            animator.startAnimation()
        }
        else {
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
                toVC.view.center = CGPoint(x: toVC.view.center.x - toVC.view.frame.width,
                                           y: toVC.view.center.y)
            }, completion: { _ in
                overlay.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
        
        // fade the dropshadow out
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = toVC.view.layer.shadowOpacity
        animation.toValue = 0.0
        animation.duration = 0.250
        toVC.view.layer.add(animation, forKey: animation.keyPath)
        toVC.view.layer.shadowOpacity = 0.0
    }
    
    private func animatePop(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        // move toVC off to the left of the screen
        toVC.view.center = CGPoint(x: toVC.view.center.x * 0.53125,
                                   y: toVC.view.center.y)
        
        // add a gray view to cover toVC
        let overlay = UIView()
        overlay.backgroundColor = Project.Colors.gray
        overlay.alpha = 0.1
        overlay.frame = fromVC.view.frame
        toVC.view.addSubview(overlay)
        
        // add toVC to the container
        transitionContext.containerView.insertSubview(toVC.view, at: 0)
        
        // set a dropshadow for fromVC
        fromVC.view.layer.shadowColor = Project.Colors.gray.cgColor
        fromVC.view.layer.shadowRadius = 5.0
        fromVC.view.layer.shadowOpacity = 0.765
        
        // slide toVC out to the right
        UIView.animate(withDuration: 0.350, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
           toVC.view.center = CGPoint(x: toVC.view.center.x / 0.53125,
                                      y: toVC.view.center.y)
        }) { (didComplete) -> Void in
        }
        
        // lighten toVC a bit
        UIView.animate(withDuration: 0.170, animations: { () -> Void in
            overlay.alpha = 0.0
        }) { (didComplete) -> Void in
        }
        
        // slide fromVC out to the right
        if #available(iOS 10.0, *) {
            let timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.17, y: 0.17), controlPoint2: CGPoint(x: 0.0, y: 1.0))
            let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), timingParameters:timing)
            animator.addAnimations {
                fromVC.view.center = CGPoint(x: fromVC.view.center.x + fromVC.view.frame.width,
                                             y: fromVC.view.center.y)
            }
            
            UIView.animate(withDuration: 0.100, animations: { () -> Void in
                toVC.view.center = CGPoint(x: (UIScreen.main.bounds.width / 2), y: fromVC.view.center.y)
            }) { (didComplete) -> Void in
            }
            
            animator.addCompletion({_ in
                overlay.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            animator.startAnimation()
        }
        else {
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
                fromVC.view.center = CGPoint(x: fromVC.view.center.x - fromVC.view.frame.width,
                                             y: fromVC.view.center.y)
            }, completion: { _ in
                overlay.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
        
        // fade the dropshadow in
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = toVC.view.layer.shadowOpacity
        animation.toValue = 0.0
        animation.duration = 0.250
        fromVC.view.layer.add(animation, forKey: animation.keyPath)
        fromVC.view.layer.shadowOpacity = 0.0
    }
}

