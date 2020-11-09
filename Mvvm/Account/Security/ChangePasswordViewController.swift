//
//  ChangePasswordViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 3/22/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class ChangePasswordViewController: AccountsAbstractController, UITextFieldDelegate {
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationTitle: NavigationLabel!
    @IBOutlet weak var oldField: TextField!
    @IBOutlet weak var newField: TextField!
    @IBOutlet weak var confirmField: TextField!
    @IBOutlet weak var goBack: UIImageView!
    @IBOutlet weak var updateButton: RedButton!
    
    @IBAction func changePassword(_ sender: RedButton) {
        print("passed 1")
        if newField.text == confirmField.text {
            print("passed 2")
           let change =  KKChangePasswordRequest()
            change?.updatedPassword = confirmField.text
            change?.oldPassword = oldField.text
            change?.email = (UIApplication.shared.delegate as! AppDelegate).authentication.value.email
            viewModel.changePassword(change!)
        }
    }
    override func viewDidLoad() {
        
        navigationBar.backgroundColor = Project.Colors.darkGreen
        navigationTitle.textColor = UIColor.white
        
        goBack.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        goBack.isUserInteractionEnabled = true
        
        oldField.errTxt = "Please enter your current password"
        oldField.defaultTxt = "OLD PASSWORD"
        oldField.delegate = self
        
        newField.errTxt = "Please enter a valid password"
        newField.defaultTxt = "NEW PASSWORD"
        newField.delegate = self
        
        confirmField.errTxt = "This doesn't match your new password"
        confirmField.defaultTxt = "CONFIRM PASSWORD"
        confirmField.delegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let retval = true
        
        //        if field == emailField {
        //            if !self.isValidEmail(testStr: field.text!){
        //                field.errTxt = field.errTxt+""
        //                retval = false
        //            } else {
        //                field.defaultTxt = field.defaultTxt+""
        //            }
        //        }
        //        else if field == passwordField {
        //            if !self.isValidPassword(testStr: field.text!){
        //                field.errTxt = field.errTxt+""
        //                retval = false
        //            } else {
        //                field.defaultTxt = field.defaultTxt+""
        //            }
        //        }
        
        return retval
    }

    func isValidPassword(testStr:String) -> Bool {
        return testStr.count >= 7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
