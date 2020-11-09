//
//  PaymentMethodsViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 3/22/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class PaymentMethodsViewController: AccountsAbstractController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var goBack: UIImageView!
    @IBOutlet weak var navigationTitle: NavigationLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPayment: RedButton!
    
    
    @IBAction func addPaymentMethod(_ sender: Any) {
        self.accountController.coordinator?.addPaymentMethod(accountViewController: self.accountController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.getCardBalance()

        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
        
        goBack.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        goBack.isUserInteractionEnabled = true
        
        tableView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        _ = viewModel?.paymentMethods.observeNext { value in
            if ( self.viewModel!.paymentMethods.count > 0 ) {
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            }
        }
        
        
        _ = viewModel?.balance.observeNext { value in
            //if (( self.viewModel!.balance) != nil) {
                DispatchQueue.main.async() {
                    
                    self.viewModel.getPaymentMethods()
                }
            //}
        }
        
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            self.accountController.coordinator?.addPaymentMethod(accountViewController: self.accountController)
            let addPay = self.navigationController?.viewControllers.last as! AddPaymentMethodViewController
            let paymentMethod = viewModel.paymentMethods[indexPath.row-1]
            let prepopulated = ["cardNumber": paymentMethod.lastFourDigits,
                                    "exp": "",
                                    "cvv": "",
                                    "methodID" : paymentMethod.paymentMethodId,
                                    "friendly": paymentMethod.friendlyName,
                                    "refIndex": String(indexPath.row - 1) ]
            addPay.prepopulated = prepopulated as! [String : String]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentMethods.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! PaymentMethodCell
        
        cell.primary.isHidden = true
        cell.cardImageView.alpha = 0
        cell.lastFour.alpha = 0
        cell.cardType.alpha = 0
        
        if (indexPath.row == 0){
            
            cell.cardImageView.image = UIImage(named: "ic_card")
            cell.cardType.isHidden = true
            
            var frame = cell.cardImageView.frame

          
            cell.contentView.layoutIfNeeded()

            
            var balance = String(describing:viewModel.balance.value.balance)
            print(balance, "my balance")
            balance = "0"//balance != "nil" ? balance : "0"
            cell.lastFour.font = cell.lastFour.font.withSize(18)
            cell.balance.isHidden = false
            cell.lastFour.isHidden = true
            cell.balance.text = "KK CARD BALANCE: $" + balance
        }else{
            let pm = viewModel.paymentMethods[indexPath.row-1]
            print("is primary", pm.primary)
            if pm.primary == 1{
                cell.primary.isHidden = false
            }
            cell.lastFour.text = "**** " + pm.lastFourDigits!
            cell.cardType.text = pm.friendlyName
            
            switch pm.creditCardType {
            case "visa"?:
                print("ee")
            case "mc"?:
                print("")
            case "disc"?:
                print("")
            case "amex"?:
                print("")
            default:
                print("yy")
            }
        }
        
        //if viewModel.paymentMethods.count > 0{
            UIView.animate(withDuration: 0.2,
                           delay: 0.3,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            cell.lastFour.alpha = 1
                            cell.cardImageView.alpha = 1
                            cell.cardType.alpha = 1
            }, completion: { (finished) -> Void in
                // ....
            })
        //}
        
        //else{
//                let pm = viewModel.paymentMethods[indexPath.row]
//               //if pm.lastFourDigits != nil {
//                  //  cell.lastFour.text = "**** " + viewModel.paymentMethods[indexPath.row].lastFourDigits!
//                //}
        
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row == 0) {
            return false
        }   else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let body = KKRemovePaymentMethodRequest()
            body?.customerId = self.viewModel.paymentMethods[indexPath.row-1].customerId
            body?.paymentMethodId = self.viewModel.paymentMethods[indexPath.row-1].paymentMethodId
            viewModel.removePaymentMethod(body!, index: indexPath.row - 1)
  
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
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
