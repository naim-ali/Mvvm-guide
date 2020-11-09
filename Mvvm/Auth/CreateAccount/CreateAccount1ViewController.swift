//
//  SignInController.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol CreateAccount1ViewControllerDelegate: class {
    func next(createAccount1ViewController: CreateAccount1ViewController)
    func goBack(createAccount1ViewController: CreateAccount1ViewController)
}

class CreateAccount1ViewController : UIViewController, UITextFieldDelegate {
    
    weak var coordinator: CreateAccount1ViewControllerDelegate?
    var viewModel: CreateAccountViewModel?
    
    @IBOutlet var goBackImageView: UIImageView!
    @IBOutlet var doughnutImageView: UIImageView!
    @IBOutlet var doughnutBottomConstraint : NSLayoutConstraint!
    
    //textFields
    @IBOutlet weak var nameField: TextField!
    @IBOutlet weak var lastNameField: TextField!
    @IBOutlet weak var dateField: TextField!
    
    //Actions
    @IBAction func next(_ sender: UIButton) {
        var isValid = true
        if (!validateField(field: nameField)) {
            isValid = false
        }
        
        if (!validateField(field: lastNameField)) {
            isValid = false
        }
        
        if (!validateField(field: dateField)) {
            isValid = false
        }
        
        if (isValid) {
            self.coordinator?.next(createAccount1ViewController: self)
        }
    }
    
    let datePickerView = DatePicker()
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        sender.inputView = datePickerView
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dateField.resignFirstResponder()
    }
    
    @objc func tappedToolBarBtn(sender: UIBarButtonItem) {
        dateField.resignFirstResponder()
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
        
        if field == nameField {
            if !self.isValidName(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        } else if field == lastNameField {
            if !self.isValidName(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        } else if field == dateField {
            if !self.isValidBirthday(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        }
        
        return retval
    }
    
    func isValidName(testStr:String) -> Bool {
        return testStr.count > 0
    }
    
    func isValidBirthday(testStr:String) -> Bool {
        if (testStr.count == 5) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            return dateFormatter.date(from: testStr) != nil
        } else if (testStr.count == 10) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.date(from: testStr) != nil
        }
        
        return false
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
        
        viewModel?.firstName.bidirectionalBind(to: nameField.reactive.text)
        viewModel?.lastName.bidirectionalBind(to: lastNameField.reactive.text)
        viewModel?.birthday.bidirectionalBind(to: dateField.reactive.text)
        _ = datePickerView.dateValue.observeNext { value in
            if (value != nil) {
                DispatchQueue.main.async() {
                    let calendar = Calendar.current
                    var dateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: value!)
                    
                    let dateFormatter = DateFormatter()
                    if (dateComponents?.year == 0001) {
                        dateFormatter.dateFormat = "MM/dd"
                    } else {
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                    }
                    self.viewModel?.birthday.value = dateFormatter.string(from: value!)
                }
            }
        }
        
        goBackImageView.addTapGestureRecognizer {
            self.coordinator?.goBack(createAccount1ViewController: self)
        }
        goBackImageView.isUserInteractionEnabled = true
        
        nameField.errTxt = "Please enter a valid first name"
        nameField.defaultTxt = "FIRST NAME*"
        nameField.delegate = self
        
        lastNameField.errTxt = "Please enter a valid last name"
        lastNameField.defaultTxt = "LAST NAME*"
        lastNameField.delegate = self
        
        dateField.errTxt = "Please enter a valid birthday"
        dateField.defaultTxt = "BIRTHDAY*"
        dateField.delegate = self
        
        // setup date toolbar
        let toolBar = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateAccount1ViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select a date"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([textBtn,flexSpace,okBarBtn], animated: true)
        
        dateField.inputAccessoryView = toolBar
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
