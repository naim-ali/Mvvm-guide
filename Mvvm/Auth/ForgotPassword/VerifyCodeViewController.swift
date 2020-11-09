//
//  SignInController.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol VerifyCodeViewControllerDelegate: class {
    func newPassword(verifyCodeViewController: VerifyCodeViewController)
    func startOver(verifyCodeViewController: VerifyCodeViewController)
    func goBack(verifyCodeViewController: VerifyCodeViewController)
}

class VerifyCodeViewController : UIViewController, UITextFieldDelegate {
    
    weak var coordinator: VerifyCodeViewControllerDelegate?
    var viewModel: ForgotPasswordViewModel?
    
    @IBOutlet weak var codeField: TextField!
    @IBOutlet var goBackImageView: UIImageView!
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    // Actions
    //---------
    @IBAction func newPassword(_ sender: UIButton) {
        if (validateField(field: codeField)) {
            LoadingReticule.sharedInstance.display()
            viewModel?.verifyCode()
        }
    }
    
    @IBAction func resendCode(_ sender: UIButton) {
        coordinator?.goBack(verifyCodeViewController: self)
    }
    
    @IBAction func startOver(_ sender: UIButton) {
        coordinator?.startOver(verifyCodeViewController: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextField Delegate
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
        
        if field == codeField {
            if !self.isValidCode(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        
        return retval
    }
    
    func isValidCode(testStr:String) -> Bool {
        return testStr.count > 0
    }
    
    // Lifecycle
    //-----------
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
        
        _ = viewModel?.codeIsValid.observeNext { value in
            DispatchQueue.main.async() {
                LoadingReticule.sharedInstance.hide()
                if (value) {
                    self.coordinator?.newPassword(verifyCodeViewController: self)
                }
            }
        }
        
        viewModel?.code.bidirectionalBind(to: codeField.reactive.text)
        
        goBackImageView.addTapGestureRecognizer {
            self.coordinator?.goBack(verifyCodeViewController: self)
        }
        goBackImageView.isUserInteractionEnabled = true
        
        codeField.errTxt = "Please enter a valid code"
        codeField.defaultTxt = "VERIFICATION CODE*"
        codeField.delegate = self
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
