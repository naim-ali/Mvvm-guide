//
//  SideMenuAnimator.swift
//  Mvvm
//
//  Created by Sagepath on 2/15/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

class SideMenuAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    static let sharedInstance = SideMenuAnimator()
    
    var baseViewController: BaseNavigationViewController?
    var presenting = true
    var originFrame = CGRect.zero
    let duration = 1.0
    var dismissCompletion: (()->Void)?
    
    var redTabContainer: UIImageView!
    var whiteTabContainer: UIImageView!
    
    
    override init(){}
    
    // load the menu animations in the background
    //-------------------------------------------
    func loadMenuTabs( loaded:@escaping () -> Void ){
        
        redTabContainer = UIImageView()
        redTabContainer.translatesAutoresizingMaskIntoConstraints = false
        redTabContainer.image = UIImage(named: "Nav Graphic")
        redTabContainer.contentMode = .scaleAspectFit
        
        whiteTabContainer = UIImageView()
        whiteTabContainer.translatesAutoresizingMaskIntoConstraints = false
        whiteTabContainer.image = UIImage(named: "White Shape Graphic")
        whiteTabContainer.contentMode = .scaleAspectFit
        
        loaded()
        
//        DispatchQueue.global(qos: .background).async {
//
//            var reds: [UIImage] = []
//            var whites: [UIImage] = []
//
//            for index in 10...82 {
//                reds.append(UIImage(named: "RED_000\(index).png")!)
//            }
//
//            for index in 10...35 {
//                whites.append(UIImage(named: "WHITE_000\(index).png")! )
//            }
//
//            DispatchQueue.main.async {
//                self.redTabContainer.animationImages = reds
//                self.redTabContainer.animationDuration = 1.2
//                self.redTabContainer.animationRepeatCount = 1
//
//                self.whiteTabContainer.animationImages = whites
//                self.whiteTabContainer.animationDuration = 1.2
//                self.whiteTabContainer.animationRepeatCount = 1
//
//                loaded()
//            }
//        }
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.333
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //On present
        if self.presenting{
           
            let menuVC = transitionContext.viewController(forKey: .to)!
            menuVC.view.frame = CGRect(x: (-1.0484375 * menuVC.view.frame.width), y: 0, width: menuVC.view.frame.width, height: menuVC.view.frame.height)
            
            
            // add menuVC to the container
            transitionContext.containerView.backgroundColor = UIColor.white
            transitionContext.containerView.addSubview(menuVC.view)
            
            if #available(iOS 10.0, *) {

                if  let menu = menuVC as? SideMenuViewController {
                    
                    // Perform spring animation for white menu tab
                    menu.menuButtonContainer!.alpha = 0
                    menu.menuButtonContainer!.frame.origin.x -= 100
//                    menu.menuButtonContainer?.transform = CGAffineTransform(scaleX: 1, y: 0.5)
//                    UIView.animate(
//                        withDuration: 0.9,
//                        delay: 1.2,
//                        usingSpringWithDamping: 0.2,
//                        initialSpringVelocity: 4.0,
//                        options: .allowUserInteraction,
//                        animations: { [weak menu] in
//                        menu?.menuButtonContainer?.transform = .identity
//                    }, completion: nil)
                }
                
                //Fade base view subviews so it doesn't clash with sideMenu
                if let subViews = self.baseViewController?.view.subviews{
                    for view in subViews as [UIView] {
                        UIView.animate(withDuration: 0.180, delay: 0, options: [.curveLinear], animations: { () -> Void in
                            if view is PassThroughView{
                                for navSubView in view.subviews as [UIView] {
                                    if navSubView.tag != 999 {
                                        navSubView.alpha = 0.3
                                    }
                                }
                            }else{
                                view.alpha = 0.3
                            }
                        })
                    }
                }
                
                //self.baseViewController?.menuButton.alpha = 0

                // menu (phase 1)
                let timing1 = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.33, y: 0.0), controlPoint2: CGPoint(x: 0.3, y: 1.0))
                let animator1 = UIViewPropertyAnimator(duration: 0.920, timingParameters:timing1)
                animator1.addAnimations {
                    menuVC.view.frame.origin.x += menuVC.view.frame.width * 0.12
                }
                UIView.animate(withDuration: 0.920, delay: 0, options: [.curveLinear], animations: { () -> Void in
                    self.baseViewController?.menuButton.alpha = 0
                })
                
                // menu (phase 2)
                let timing2 = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.7, y: 0.0), controlPoint2: CGPoint(x: 0.83, y: 0.83))
                let animator2 = UIViewPropertyAnimator(duration: 0.620, timingParameters: timing2)
                animator2.addAnimations {
                    menuVC.view.frame.origin.x = 0
                    self.baseViewController?.menuButtonContainer.frame.origin.x += menuVC.view.frame.size.width + 20
                    self.baseViewController?.menuButton.frame.origin.x += menuVC.view.frame.size.width
                }
                
                // menu (phase 2 complete)
                animator2.addCompletion({_ in
                    // reset left button
                    if  let menu = menuVC as? SideMenuViewController {
                     menu.menuButtonContainer!.alpha = 1
                    }
                    self.baseViewController?.menuButtonLeadingConstraint.constant = 0
                    transitionContext.completeTransition(true)
                    self.baseViewController?.menuButtonContainer.frame.origin.x = 0
                    self.baseViewController?.menuButton.frame.origin.x = 0
                })
                
                // animate phase 1
                //self.baseViewController?.menuButtonContainer.startAnimating()
                //animator1.startAnimation()
                
                // Move the tab backwards as animation progresses
                UIView.animate(withDuration: 0.280, delay: 0.917, options: [.curveLinear], animations: { () -> Void in
                   // self.baseViewController?.menuButtonContainer.frame.origin.x -= 7.5
                })
                animator2.startAnimation(afterDelay: 0)
            }
            
        }else{
            //On dismiss
            let menuVC = transitionContext.viewController(forKey: .from)!
            let baseVC = transitionContext.viewController(forKey: .to)!
            baseVC.view.frame = CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: baseVC.view.frame.height)
            menuVC.view.frame = CGRect(x: 0, y: 0, width: menuVC.view.frame.width, height: menuVC.view.frame.height)
            
            // add menuVC to the container
            transitionContext.containerView.addSubview(baseVC.view)
            transitionContext.containerView.addSubview(menuVC.view)
            
            
            if #available(iOS 10.0, *) {

                let timing1 = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.3, y: 0.0), controlPoint2: CGPoint(x: 0.33, y: 0))
                let animator1 = UIViewPropertyAnimator(duration: 0.420, timingParameters:timing1)
                animator1.addAnimations {
                    menuVC.view.frame.origin.x += -menuVC.view.frame.width
                }
                
                //Fade back in base view subviews
                if let subViews = self.baseViewController?.view.subviews{
                    for view in subViews as [UIView] {
                        UIView.animate(withDuration: 0.180, delay: 0, options: [.curveLinear], animations: { () -> Void in
                            if view is PassThroughView{
                                for navSubView in view.subviews as [UIView] {
                                    navSubView.alpha = 1
                                }
                            }else{
                                view.alpha = 1
                            }
                        })
                    }
                }
                

                animator1.addCompletion({_ in
                    // reset red tab
                    self.baseViewController?.menuButtonLeadingConstraint.constant = -2
                    self.baseViewController?.menuButton.alpha = 1.0
                    
                    //Bounce animation for red tab
//                    self.baseViewController?.menuButtonContainer?.transform = CGAffineTransform(scaleX: 1, y: 0.5)
//                    UIView.animate(withDuration: 0.9,
//                                   delay: 0,
//                                   usingSpringWithDamping: 0.2,
//                                   initialSpringVelocity: 4.0,
//                                   options: .allowUserInteraction,
//                                   animations: { [weak self] in
//                                    self?.baseViewController?.menuButtonContainer?.transform = .identity
//                        },completion: nil)
                    
                    //Move animation for main button
                    if self.baseViewController?.mainButton !== nil {
                        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: { () -> Void in
                            self.baseViewController?.mainButton.frame.origin.x += 10;
                        }, completion: { (finished: Bool) in
                            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: { () -> Void in
                                self.baseViewController?.mainButton.frame.origin.x -= 10;
                            })
                        })
                    }
                    transitionContext.completeTransition(true)
                })
                
                // animate phase 1
                if  let menu = menuVC as? SideMenuViewController {
                        menu.menuButtonContainer!.startAnimating()
                    
                    UIView.animate(withDuration: 0.920, delay: 0, options: [.curveLinear], animations: { () -> Void in
                        menu.menuButtonContainer!.alpha = 1
                        menu.menuButtonContainer!.frame.origin.x += 2
                    })
                }
                
                animator1.startAnimation()
                
                // animate phase 2
                UIView.animate(withDuration: 0.180, delay: 0.917, options: [.curveLinear], animations: { () -> Void in
                    self.baseViewController?.menuButton.alpha = 0
                })
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            self.presenting = true
            return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("called last")
        self.presenting = false
        return self
    }
}

extension SideMenuAnimator : UIViewControllerTransitioningDelegate {
    
}
