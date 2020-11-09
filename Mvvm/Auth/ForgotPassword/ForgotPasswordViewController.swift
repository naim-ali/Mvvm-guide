//
//  ForgotPasswordViewController.swift
//  Mvvm
//
//  Created by Sagepath on 2/19/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

protocol ForgotPasswordViewControllerDelegate: class {
    func sendVerificationCode(forgotPasswordViewController: ForgotPasswordViewController)
    func goBack(forgotPasswordViewController: ForgotPasswordViewController)
}

class ForgotPasswordViewController : UIViewController, UITextFieldDelegate {
    
    weak var coordinator: ForgotPasswordViewControllerDelegate?
    var viewModel: ForgotPasswordViewModel?
    
    @IBOutlet weak var emailField: TextField!
    @IBOutlet var goBackImageView: UIImageView!
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    // Actions
    @IBAction func sendVerificationCode(_ sender: UIButton) {
        if (validateField(field: emailField)) {
            LoadingReticule.sharedInstance.display()
            viewModel?.forgotPassword()
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextfield delegate
    //---------------------
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
        
        if field == emailField {
            if !self.isValidEmail(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        
        return retval
    }
    
    // Lifecylce
    //----------
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
        
        _ = viewModel?.codeIsSent.observeNext { value in
            DispatchQueue.main.async() {
                LoadingReticule.sharedInstance.hide()
                if (value) {
                    self.coordinator?.sendVerificationCode(forgotPasswordViewController: self)
                }
            }
        }
        
        viewModel?.email.bidirectionalBind(to: emailField.reactive.text)
        
        goBackImageView.addTapGestureRecognizer {
            self.coordinator?.goBack(forgotPasswordViewController: self)
        }
        goBackImageView.isUserInteractionEnabled = true
        
        emailField.errTxt = "Please Enter a valid email address"
        emailField.defaultTxt = "EMAIL ADDRESS*"
        emailField.delegate = self
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
