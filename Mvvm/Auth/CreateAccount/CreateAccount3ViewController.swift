//
//  SignInController.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol CreateAccount3ViewControllerDelegate: class {
    func createAccount(createAccount3ViewController: CreateAccount3ViewController)
    func goBack(createAccount3ViewController: CreateAccount3ViewController)
}

class CreateAccount3ViewController : UIViewController, UITextFieldDelegate {
    
    weak var coordinator: CreateAccount3ViewControllerDelegate?
    var viewModel: CreateAccountViewModel?
    
    var passwordVisible : Bool!
    var useTouchID : Bool!
    
    //textFields
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var emailField: TextField!
    
    //buttons
    @IBOutlet weak var toggleTouchID: PlainButton!
    @IBOutlet weak var passwordVisibilityToggle: UIButton!
    
    @IBOutlet var goBackImageView: UIImageView!
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    //actions
    @IBAction func signUp(_ sender: UIButton) {
        var isValid = true
        if (!validateField(field: emailField)) {
            isValid = false
        }
        
        if (!validateField(field: passwordField)) {
            isValid = false
        }
        
        if (isValid) {
            LoadingReticule.sharedInstance.display()
            viewModel?.createAccount()
        }
    }
    
    @IBAction func toggleTouchID(_ sender: UIButton) {
        if(useTouchID == true) {
            toggleTouchID.setImage(UIImage(named:"ic_touch-id-inactive"), for: .normal)
            toggleTouchID.setTitle("Enable Touch ID", for: .normal)
            self.useTouchID = false
        } else {
            toggleTouchID.setImage(UIImage(named:"ic_touch-id-active"), for: .normal)
            toggleTouchID.setTitle("Disable Touch ID", for: .normal)
            self.useTouchID = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextField Delegate
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
        
        if field == emailField {
            if !self.isValidEmail(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        else if field == passwordField {
            if !self.isValidPassword(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        
        return retval
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr:String) -> Bool {
        return testStr.count >= 7
    }
    
    // Life Cycle
    //---------------
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
        
        viewModel?.email.bidirectionalBind(to: emailField.reactive.text)
        viewModel?.password.bidirectionalBind(to: passwordField.reactive.text)
        
        _ = viewModel?.authentication.observeNext { value in
            DispatchQueue.main.async() {
                LoadingReticule.sharedInstance.hide()
                if (value.isAuthorized) {
                    self.coordinator?.createAccount(createAccount3ViewController: self)
                }
            }
        }
        
        goBackImageView.addTapGestureRecognizer {
            self.coordinator?.goBack(createAccount3ViewController: self)
        }
        goBackImageView.isUserInteractionEnabled = true
        
        emailField.errTxt = "Please Enter a valid email address"
        emailField.defaultTxt = "EMAIL ADDRESS*"
        emailField.delegate = self
        
        passwordField.errTxt = "Please Enter a valid password"
        passwordField.defaultTxt = "ENTER PASSWORD*"
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        passwordVisible = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doughnutBottomConstraint.constant = doughnutImageView.frame.height * -1
        self.view.layoutIfNeeded()
        
        toggleTouchID.setImage(UIImage(named:"ic_touch-id-inactive"), for: .normal)
        toggleTouchID.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        toggleTouchID.titleEdgeInsets = UIEdgeInsets(top: 2,left: 0,bottom: 0,right: 0)
        toggleTouchID.setTitle("Enable Touch ID", for: .normal)
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
