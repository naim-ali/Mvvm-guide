//
//  AddPaymentMethodViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 3/22/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class AddPaymentMethodViewController: AccountsAbstractController, UITextFieldDelegate, CardIOPaymentViewControllerDelegate {

    @IBOutlet weak var goBack: UIImageView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationTitle: NavigationLabel!
    @IBOutlet weak var digitsField: TextField!
    @IBOutlet weak var scanCardBtn: UIButton!
    @IBOutlet weak var experationDate: TextField!
    @IBOutlet weak var cvv: TextField!
    @IBOutlet weak var cardName: TextField!
    @IBOutlet weak var addCard: RedButton!
    @IBOutlet weak var removeCard: UIButton!
    @IBOutlet weak var primaryToggle: PlainButton!
    
    var usePrimary : Bool!
    var prepopulated : [String : String]!
    var paymentMethodId : String!
    var refIndex : Int!
    
    @IBAction func scanCard(_ sender: Any) {
        startScanning()
    }
    
    @IBAction func togglePrimary(_ sender: UIButton) {
        if(usePrimary == true) {
            primaryToggle.setImage(UIImage(named:"ic_touch-id-inactive"), for: .normal)
            self.usePrimary = false
        } else {
            primaryToggle.setImage(UIImage(named:"ic_touch-id-active"), for: .normal)
            self.usePrimary = true
        }
    }
    @IBAction func addCard(_ sender: Any) {
        let authentication = (UIApplication.shared.delegate as! AppDelegate).authentication
        var body = KKUpdatePaymentMethodRequest()
        body?.customerId = authentication.value.customerId
        if digitsField.text?.range(of:"*") == nil {
            body?.cardNumber = digitsField.text
        }else{
            body?.cardNumber = ((self.prepopulated as AnyObject).object(forKey: "cardNumber") as? String)!
        }
        
        body?.cvvCode = cvv.text
        body?.expirationDate = experationDate.text
        body?.friendlyName = cardName.text
        body?.paymentMethodId = self.paymentMethodId == nil ? nil : self.paymentMethodId
        body?.primary = usePrimary as NSNumber
        print("||EDIT PAYMENT METHOD BLANK CARD#||", body)
        viewModel.addPaymentMethod(body!)
        self.navigationController?.popViewController(animated: true)
    }
//    func luhnCheck(number: String) -> Bool {
//        var sum = 0
//        let digitStrings = number.reversed().map { String($0) }
//
//        for tuple in digitStrings.enumerated() {
//            guard let digit = Int(tuple.element) else { return false }
//            let odd = tuple.offset % 2 == 1
//
//            switch (odd, digit) {
//            case (true, 9):
//                sum += 9
//            case (true, 0...8):
//                sum += (digit * 2) % 9
//            default:
//                sum += digit
//            }
//        }
//
//        return sum % 10 == 0
//    }
//
//    enum CardType: String {
//        case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
//
//        static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
//
//        var regex : String {
//            switch self {
//            case .Amex:
//                return "^3[47][0-9]{5,}$"
//            case .Visa:
//                return "^4[0-9]{6,}([0-9]{3})?$"
//            case .MasterCard:
//                return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
//            case .Diners:
//                return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
//            case .Discover:
//                return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
//            case .JCB:
//                return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
//            case .UnionPay:
//                return "^(62|88)[0-9]{5,}$"
//            case .Hipercard:
//                return "^(606282|3841)[0-9]{5,}$"
//            case .Elo:
//                return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
//            default:
//                return ""
//            }
//        }
//    }
//
//    func matchesRegex(regex: String!, text: String!) -> Bool {
//        do {
//            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
//            let nsString = text as NSString
//            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
//            return (match != nil)
//        } catch {
//            return false
//        }
//    }
//
//    func checkCardNumber(input: String) -> (type: CardType, formatted: String, valid: Bool) {
//        // Get only numbers from the input string
//
//        var numberOnly = self.digitsField.text!
//        numberOnly = numberOnly.replacingOccurrences(of: "[^0-9]", with: .RegularExpressionSearch)
//
//
////        let numberOnly = digitsField.text.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch)
//
//        var type: CardType = .Unknown
//        var formatted = ""
//        var valid = false
//
//        // detect card type
//        for card in CardType.allCards {
//            if (matchesRegex(card.regex, text: numberOnly)) {
//                type = card
//                break
//            }
//        }
//
//        // check validity
//        valid = luhnCheck(numberOnly)
//
//        // format
//        var formatted4 = ""
//        for character in numberOnly.characters {
//            if formatted4.characters.count == 4 {
//                formatted += formatted4 + " "
//                formatted4 = ""
//            }
//            formatted4.append(character)
//        }
//
//        formatted += formatted4 // the rest
//
//        // return the tuple
//        return (type, formatted, valid)
//    }
    
    @IBAction func removeCard(_ sender: Any) {
        let authentication = (UIApplication.shared.delegate as! AppDelegate).authentication
        let body = KKRemovePaymentMethodRequest()
        body?.customerId = authentication.value.customerId
        body?.paymentMethodId = self.paymentMethodId == nil ? nil : self.paymentMethodId
        viewModel.removePaymentMethod(body!, index: refIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
        
        goBack.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        goBack.isUserInteractionEnabled = true
        
        
//        // setup date toolbar
//        let toolBar = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height: 40.0))
//        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
//        toolBar.barStyle = UIBarStyle.blackTranslucent
//        toolBar.tintColor = UIColor.white
//        toolBar.backgroundColor = UIColor.black
//
//        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateAccount1ViewController.donePressed))
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
//
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
//        label.font = UIFont(name: "Helvetica", size: 12)
//        label.backgroundColor = UIColor.clear
//        label.textColor = UIColor.white
//        label.text = "Select a date"
//        label.textAlignment = NSTextAlignment.center
//
//        let textBtn = UIBarButtonItem(customView: label)
//
//        toolBar.setItems([textBtn,flexSpace,okBarBtn], animated: true)
//
//        digitsField.inputAccessoryView = toolBar
        
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
        
        digitsField.errTxt = "Please enter a valid card number"
        digitsField.defaultTxt = "CARD NUMBER"
        digitsField.delegate = self
        
        experationDate.errTxt = "Please enter a valid experation date"
        experationDate.defaultTxt = "EXPIRATION DATE"
        experationDate.delegate = self
        
        cvv.errTxt = "Please provide a valid CVV"
        cvv.defaultTxt = "CVV"
        cvv.delegate = self
        
        cardName.errTxt = "Please enter a name"
        cardName.defaultTxt = "CARD NAME"
        cardName.delegate = self
        
        usePrimary = false
        
        self.addDoneButtonOnKeyboard()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if prepopulated != nil {
            self.addCard.titleLabel?.text = "UPDATE"
            self.navigationTitle.text = "EDIT PAYMENT METHOD"
            removeCard.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        primaryToggle.imageView?.contentMode = .scaleAspectFit;
        primaryToggle.setImage(UIImage(named:"ic_touch-id-inactive"), for: .normal)
        primaryToggle.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        primaryToggle.titleEdgeInsets = UIEdgeInsets(top: 2,left: 0,bottom: 0,right: 0)
        primaryToggle.setTitle("Make Primary Payment Method", for: .normal)
        
        if prepopulated != nil {
            let fields = prepopulated as? AnyObject
            self.addCard.titleLabel?.text = "UPDATE CARD"
            digitsField.text = "**** **** **** " + (fields?.object(forKey: "cardNumber") as? String)!
            experationDate.text = fields?.object(forKey: "exp") as? String
            cvv.text = fields?.object(forKey: "cvv") as? String
            cardName.text = fields?.object(forKey: "friendly") as? String
            paymentMethodId = fields?.object(forKey: "methodID") as? String
            refIndex = Int((fields?.object(forKey: "refIndex") as? String)!)
        }else{
            self.digitsField.becomeFirstResponder()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        prepopulated = nil
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
        
        self.digitsField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.digitsField.resignFirstResponder()
    }
    
    func startScanning() {
        // Do your scannner implementation here
        /// Create CardIOPaymentViewController object with paymentDelegate to self.
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        
        /// Set to true if you need to collect the cardholder name. Defaults to false.
        //cardIOVC?.collectCardholderName = true
        
        /// Hide the PayPal or card.io logo in the scan view. Defaults to false.
        cardIOVC?.hideCardIOLogo = true
        
        /// Set the guide color, Defaults to nil; if nil, will use card.io green.
        cardIOVC?.guideColor = UIColor.white

        /// Set to false if you don't need to collect the CVV from the user. Defaults to true.
        cardIOVC?.collectCVV = true
        
        
        /// A custom view that will be overlaid atop the entire scan view. Defaults to nil.
        //        let overlay = UIView(frame: cardIOVC.view.frame)
        //        overlay.backgroundColor = UIColor.blueColor()
        //        overlay.alpha = 0.3
        //        cardIOVC.scanOverlayView = overlay
        
        /// Present Card Scanner View modally.
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    //MARK :- CardIOPaymentViewControllerDelegate
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let exp = NSString(format: "%02lu/%lu", info.expiryMonth, info.expiryYear)
            digitsField.text = info.cardNumber
            experationDate.text = exp as String
            cvv.text = info.cvv
            cardName.text = info.cardholderName
            
        }
        paymentViewController.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
