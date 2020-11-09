//
//  SignInController.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol CreateAccount2ViewControllerDelegate: class {
    func next(createAccount2ViewController: CreateAccount2ViewController)
    func goBack(createAccount2ViewController: CreateAccount2ViewController)
}

class CreateAccount2ViewController : UIViewController, UITextFieldDelegate {
    
    weak var coordinator: CreateAccount2ViewControllerDelegate?
    var viewModel: CreateAccountViewModel?
    
    @IBOutlet var goBackImageView: UIImageView!
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    //textFields
    @IBOutlet weak var zipField: TextField!
    @IBOutlet weak var phoneField: TextField!
    @IBOutlet weak var promoField: TextField!
    
    //Actions
    @IBAction func next(_ sender: UIButton) {
        var isValid = true
        if (!validateField(field: zipField)) {
            isValid = false
        }
        
        if (!validateField(field: phoneField)) {
            isValid = false
        }
        
        if (!validateField(field: promoField)) {
            isValid = false
        }
        
        if (isValid) {
            self.coordinator?.next(createAccount2ViewController: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        if field == zipField {
            if !self.isValidZip(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        } else if field == phoneField {
            if !self.isValidPhone(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        } else if field == promoField {
            if !self.isValidPromo(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        
        return retval
    }
    
    func isValidZip(testStr:String) -> Bool {
        let justDigits = testStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return (justDigits.count == 5 || justDigits.count == 9)
    }
    
    func isValidPhone(testStr:String) -> Bool {
        let justDigits = testStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return justDigits.count == 10
    }
    
    func isValidPromo(testStr:String) -> Bool {
        return true // idk
    }
    
    // Lifecycle
    //-----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModel?.errorMessages.observeNext { error in
            DispatchQueue.main.async() {
                //LoadingReticule.sharedInstance.hide()
                let alertController = UIAlertController(title: "Oh no!", message: error, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                let actionOk = UIAlertAction(title: "OK", style: .default,
                                             handler: { action in alertController.dismiss(animated: true, completion: nil) })
                
                alertController.addAction(actionOk)
            }
        }
        
        viewModel?.zip.bidirectionalBind(to:zipField.reactive.text)
        viewModel?.phone.bidirectionalBind(to: phoneField.reactive.text)
        viewModel?.promo.bidirectionalBind(to: promoField.reactive.text)
        
        goBackImageView.addTapGestureRecognizer {
            self.coordinator?.goBack(createAccount2ViewController: self)
        }
        goBackImageView.isUserInteractionEnabled = true
        
        zipField.errTxt = "Please enter a valid zip code"
        zipField.defaultTxt = "ZIP CODE*"
        zipField.delegate = self
        
        phoneField.errTxt = "Please enter a valid mobile phone number"
        phoneField.defaultTxt = "MOBILE PHONE NUMBER*"
        phoneField.delegate = self
        
        promoField.errTxt = "Please enter a valid promo code"
        promoField.defaultTxt = "PROMO CODE"
        promoField.delegate = self
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

