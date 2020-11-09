//
//  SignInController.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol NewPasswordViewControllerDelegate: class {
    func goBack(newPasswordViewController: NewPasswordViewController)
    func confirm(newPasswordViewController: NewPasswordViewController)
}

class NewPasswordViewController : UIViewController, UITextFieldDelegate {
    
    weak var coordinator: NewPasswordViewControllerDelegate?
    var viewModel: ForgotPasswordViewModel?
    
    var passwordVisible : Bool!
    
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet var goBackImageView: UIImageView!
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    //buttons
    @IBOutlet weak var passwordVisibilityToggle: UIButton!
    
    //Actions
    @IBAction func confirm(_ sender: UIButton) {
        if (validateField(field: passwordField)) {
            LoadingReticule.sharedInstance.display()
            viewModel?.resetPassword()
        }
    }
    
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        if(passwordVisible == true) {
            passwordField.isSecureTextEntry = true
            passwordVisibilityToggle.setImage(UIImage(named: "ic_show_password"), for: .normal)
            self.passwordVisible = false
        } else {
            passwordField.isSecureTextEntry = false
            passwordVisibilityToggle.setImage(UIImage(named: "ic_hide_password"), for: .normal)
            self.passwordVisible = true
        }
        
        // stupid hack to put the cursor in the right position
        let passwordText = passwordField.text
        passwordField.text = nil
        passwordField.text = passwordText
    }
    
    // UITextField delegate
    //----------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let field = textField as! TextField
        field.focus()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if let field = textField as? TextField{
            _ = validateField(field: field)
            field.blur()
        }
        return true
    }
    
    func validateField(field: TextField) -> Bool {
        var retval = true
        
        if field == passwordField {
            if !self.isValidPassword(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        
        return retval
    }
    
    func isValidPassword(testStr:String) -> Bool {
        return testStr.count >= 7
    }
    
    // Lifecycle
    //----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModel?.errorMessages.observeNext { error in
            DispatchQueue.main.async() {
                LoadingReticule.sharedInstance.hide()
                let alertController = UIAlertController(title: "Oh no!", message: error, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                let actionOk = UIAlertAction(title: "OK", style: .default,
                                             handler: { action in alertController.dismiss(animated: true, completion: nil) })
                
                alertController.addAction(actionOk)
            }
        }
        
        _ = viewModel?.authentication.observeNext { value in
            DispatchQueue.main.async() {
                LoadingReticule.sharedInstance.hide()
                if (value.isAuthorized) {
                    self.coordinator?.confirm(newPasswordViewController: self)
                }
            }
        }
        viewModel?.password.bidirectionalBind(to: passwordField.reactive.text)
        
        goBackImageView.addTapGestureRecognizer {
            self.coordinator?.goBack(newPasswordViewController: self)
        }
        goBackImageView.isUserInteractionEnabled = true
        
        passwordField.errTxt = "Please enter a valid password"
        passwordField.defaultTxt = "ENTER PASSWORD*"
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        passwordVisible = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //doughnutBottomConstraint.constant = doughnutImageView.frame.height * -1
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            let timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.17, y: 0.17), controlPoint2: CGPoint(x: 0.0, y: 1.0))
            let animator = UIViewPropertyAnimator(duration: 0.500, timingParameters:timing)
            animator.addAnimations {
                //self.doughnutBottomConstraint.constant = 0
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
