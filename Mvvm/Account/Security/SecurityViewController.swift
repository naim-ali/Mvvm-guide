//
//  SecurityViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 3/20/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class SecurityViewController: AccountsAbstractController, UITextFieldDelegate {

    @IBOutlet weak var nameField: TextField!
    @IBOutlet weak var lastNameField: TextField!
    @IBOutlet var dobField: TextField!
    @IBOutlet weak var zipField: TextField!
    
    @IBOutlet weak var phoneField: TextField!
    
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationTitle: NavigationLabel!
    @IBOutlet weak var goBack: UIImageView!
    
    @IBOutlet weak var doneBtn: RedButton!
    @IBOutlet weak var toggleTouchID: PlainButton!
    @IBOutlet weak var updatePasswordLabel: UILabel!
    @IBOutlet weak var updatePasswordView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let datePickerView = DatePicker()
    
    @IBAction func done(_ sender: UIButton) {
        self.viewModel.updateAccount()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        sender.inputView = datePickerView
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dobField.resignFirstResponder()
    }
    
    @objc func tappedToolBarBtn(sender: UIBarButtonItem) {
        dobField.resignFirstResponder()
    }
    
    var useTouchID : Bool!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("authentication", (UIApplication.shared.delegate as! AppDelegate).authentication.value )
        let auth = (UIApplication.shared.delegate as! AppDelegate).authentication.value
        
        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
        
        goBack.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        goBack.isUserInteractionEnabled = true
        
        
        
        
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
        
        dobField.inputAccessoryView = toolBar

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
        viewModel?.zip.bidirectionalBind(to: zipField.reactive.text)
        viewModel?.phoneNumber.bidirectionalBind(to: phoneField.reactive.text)
        viewModel?.birthday.bidirectionalBind(to: dobField.reactive.text)
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

        nameField.errTxt = "Please Enter your first name"
        nameField.defaultTxt = "FIRST NAME"
        nameField.delegate = self
        nameField.text = auth.firstName
        
        lastNameField.errTxt = "Please Enter your last name"
        lastNameField.defaultTxt = "LAST NAME"
        lastNameField.delegate = self
        lastNameField.text = auth.lastName
        
        dobField.errTxt = "Please enter your birthday"
        dobField.defaultTxt = "BIRTHDAY"
        dobField.delegate = self
        dobField.isUserInteractionEnabled = false
        dobField.textColor = UIColor(red:0.79, green:0.79, blue:0.79, alpha:1.0)
        dobField.text = convertDateFormatter(date: auth.birthday!)
        
        zipField.errTxt = "Please enter a valid zip code"
        zipField.defaultTxt = "ZIP CODE"
        zipField.delegate = self
        zipField.keyboardType = UIKeyboardType.decimalPad
        zipField.text = auth.loyaltyZipCode
        
        
        var phone : String!
        phone = String(describing: auth.voicePhone!)
        phone.insert("-", at: String.Index(encodedOffset: 3))
        phone.insert("-", at: String.Index(encodedOffset: 7))
        
        phoneField.errTxt = "Please enter a valid phone number"
        phoneField.defaultTxt = "MOBILE PHONE NUMBER"
        phoneField.delegate = self
        phoneField.text = phone
     
        phoneField.keyboardType = UIKeyboardType.decimalPad
        phoneField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addDoneButtonOnKeyboard()
        
        updatePasswordLabel.textColor = Project.Colors.darkGreen
        updatePasswordView.addTapGestureRecognizer {
            self.changePassword()
            //self.navigationController?.popViewController(animated: true)
        }
        updatePasswordView.isUserInteractionEnabled = true
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(SecurityViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(SecurityViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SecurityViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.phoneField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.phoneField.resignFirstResponder()
    }
    
    
    func convertDateFormatter(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "MM/dd/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        toggleTouchID.imageView?.contentMode = .scaleAspectFit;
//        toggleTouchID.setImage(UIImage(named:"ic_touch-id-inactive"), for: .normal)
//        toggleTouchID.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
//        toggleTouchID.titleEdgeInsets = UIEdgeInsets(top: 2,left: 0,bottom: 0,right: 0)
//        toggleTouchID.setTitle("Enable Touch ID", for: .normal)
        
        let height = doneBtn.frame.size.height
        let pos = doneBtn.frame.origin.y
        let sizeOfContent = height + pos + 20
        scrollView.contentSize.height = sizeOfContent
        self.view.layoutIfNeeded()
        
    }
    
    func changePassword(){
        self.accountController?.coordinator?.changePassword(accountViewController: accountController!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if phoneField.isEditing{
            let info:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            
            var keyboardHeight: CGFloat = keyboardSize.height
            if(keyboardHeight < 1){
                keyboardHeight = 260.0
            }
            
            let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as! CGFloat
            
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseInOut, animations: {
                print("about to animate", keyboardHeight)
                self.view.frame = CGRect(x: 0, y: (self.view.frame.origin.y - keyboardHeight), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if phoneField.isEditing{
            let info: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            
            let keyboardHeight: CGFloat = keyboardSize.height
            
            let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as! CGFloat
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                
                self.view.frame = CGRect(x: 0, y: (self.view.frame.origin.y + keyboardHeight), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // UITextfield delegate
    //---------------------
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("changes made")
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }else{
            if textField.text?.count == 3 && textField.text?.last != "-"{
                textField.text = textField.text! + "-"
            }else if textField.text?.count == 7 && textField.text?.last != "-"{
                textField.text = textField.text! + "-"
            }
        }
        return true
    }
    
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
        } else if field == dobField {
            if !self.isValidBirthday(testStr: field.text!){
                field.errTxt = field.errTxt+""
                retval = false
            } else {
                field.defaultTxt = field.defaultTxt+""
            }
        } else if field == zipField {
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
        }
        
        return retval
    }
    
    func isValidName(testStr:String) -> Bool {
        return testStr.count > 0
    }
    
    func isValidZip(testStr:String) -> Bool {
        let justDigits = testStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return (justDigits.count == 5 || justDigits.count == 9)
    }
    
    func isValidPhone(testStr:String) -> Bool {
        let justDigits = testStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return justDigits.count == 10
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
