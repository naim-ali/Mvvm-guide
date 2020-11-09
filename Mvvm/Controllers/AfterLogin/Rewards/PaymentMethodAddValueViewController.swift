//
//  PaymentMethodAddValueViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/12/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class PaymentMethodAddValueViewController: UIViewController, UITextFieldDelegate {
/*
    var paymentMethod: IPaymentMethod?
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var paymentMethodDisplayNameLabel: UILabel!
    @IBOutlet weak var addValueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        paymentMethodDisplayNameLabel.text = paymentMethod?.displayName
        valueTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier {
            if id == "addValue" {
                // add value to card via api
                if let valueAddedController = segue.destination as? ValueAddedViewController {
                    valueAddedController.valueAdded = valueTextField.text
                }
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addValueButton.titleLabel?.text = "ADD \(textField.text!)"
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    */
}
