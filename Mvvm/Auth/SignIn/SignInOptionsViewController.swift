//
//  SignInOptionsController.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol SignInOptionsViewControllerDelegate: class {
    func signIn(signInOptionsViewController: SignInOptionsViewController)
    func createAccount(signInOptionsViewController: SignInOptionsViewController)
    func continueAsGuest(signInOptionsViewController: SignInOptionsViewController)
}

class SignInOptionsViewController : UIViewController
{
    weak var coordinator: SignInOptionsViewControllerDelegate?
    @IBAction func signIn(_ sender: UIButton) {
        self.coordinator?.signIn(signInOptionsViewController: self)
    }
    @IBAction func createAccount(_ sender: UIButton) {
        self.coordinator?.createAccount(signInOptionsViewController: self)
    }
    @IBAction func continueAsGuest(_ sender: UIButton) {
        self.coordinator?.continueAsGuest(signInOptionsViewController: self)
    }
    
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doughnutBottomConstraint.constant = doughnutImageView.frame.height * -1
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            let timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.17, y: 0.17), controlPoint2: CGPoint(x: 0.0, y: 1.0))
            let animator = UIViewPropertyAnimator(duration: 0.500, timingParameters:timing)
            animator.addAnimations {
                self.doughnutBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()
        }
        else {
            UIView.animate(withDuration: 0.500, animations: {
                self.doughnutBottomConstraint.constant = 0
            })
        }
    }
}
