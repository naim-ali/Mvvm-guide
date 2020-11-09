//
//  AddPaymentMethodTableViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/12/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class AddPaymentMethodTableViewController: UITableViewController {
/*
    var paymentMethods: [IPaymentMethod]! = [IPaymentMethod]()
    var paymentMethodService: IPaymentMethodService!
    let redColor = UIColor(red: 208.0 / 255.0, green: 31.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    var primaryPaymentMethod:IPaymentMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentMethodService = TestPaymentMethodService()
        
        paymentMethods = paymentMethodService.GetPaymentMethodsFor(user: "me")
        
        primaryPaymentMethod = paymentMethodService.GetPrimaryPaymentMethodFor(user: "me")
        
        if let paymentMethod = primaryPaymentMethod {
            paymentMethods = paymentMethods.sorted { ($0.displayName == paymentMethod.displayName ? 1 : 0) > ($1.displayName == paymentMethod.displayName ? 1 : 0) }
        }
        
        navigationItem.setHidesBackButton(true, animated: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if paymentMethods.isEmpty {
            return 2;
        } else {
            return paymentMethods.count + 2
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if paymentMethods.isEmpty {
            switch(indexPath.row) {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodEmptyCell", for: indexPath)
                cell.separatorInset = UIEdgeInsetsMake(0.0, UIScreen.main.bounds.width, 0.0, 0.0)
                cell.selectionStyle = .none
                return cell;
            default:
                return GetAPaymentMethodFooterCell(withIndexPath: indexPath)
                
            }
        } else {
            switch(indexPath.row) {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodTitleCell", for: indexPath)
                cell.separatorInset = UIEdgeInsetsMake(0.0,0.0,0.0,0.0)
                cell.selectionStyle = .none
                return cell
            case paymentMethods.count + 1:
                return GetAPaymentMethodFooterCell(withIndexPath: indexPath)
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodCell", for: indexPath) as! PaymentMethodTableViewCell
                let paymentMethod = paymentMethods[indexPath.row - 1]
                
                let displayNameAttrStr = NSMutableAttributedString(string: paymentMethod.displayName)
                displayNameAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, displayNameAttrStr.length))
                cell.displayNameLabel.attributedText = displayNameAttrStr
                
                cell.imageView?.image = paymentMethod.image
                cell.tintColor = UIColor(red: 208.0 / 255.0, green: 31.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
                cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
                
                if let primaryPaymentMethod = primaryPaymentMethod {
                    cell.primaryPaymentMethodLabel.isHidden = primaryPaymentMethod.displayName != paymentMethod.displayName
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        
        
        
    }
    
    private func GetScreenHeightDifferenceFor(height:CGFloat) -> CGFloat {
        let tableViewHeight = Double(paymentMethods.count) * 67.0 + 125.0
        
        var difference = UIScreen.main.bounds.height - CGFloat(tableViewHeight) - UIApplication.shared.statusBarFrame.height
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            difference -= navBarHeight
        }
        return difference
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if paymentMethods.isEmpty {
            switch(indexPath.row) {
            case 1:
                return 125.0
            default:
                return GetScreenHeightDifferenceFor(height: 125.0)
            }
        } else {
            switch(indexPath.row) {
            case 0:
                return 125.0
            case paymentMethods.count + 1:
                let difference = GetScreenHeightDifferenceFor(height: 125.0)
                return difference > 0 ? difference : 125.0
            default:
                return 67.0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch(indexPath.row) {
//        case paymentMethods.count + 1:
//            return
//        default:
//            let paymentMethod = paymentMethods[indexPath.row - 1]
//            if let paymentMethodAddValueController = storyboard?.instantiateViewController(withIdentifier: "paymentMethodAddValue") as? PaymentMethodAddValueViewController {
//                paymentMethodAddValueController.paymentMethod = paymentMethod
//                navigationController?.pushViewController(paymentMethodAddValueController, animated: true)
//            }
//        }
    }
    
    private func GetAPaymentMethodFooterCell(withIndexPath indexPath: IndexPath) -> PaymentMethodFooterTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodFooterCell", for: indexPath) as! PaymentMethodFooterTableViewCell
        cell.addPaymentMethodButton.layer.shadowOffset.height = 5.0
        cell.addPaymentMethodButton.layer.shadowOpacity = 0.7
        cell.addPaymentMethodButton.layer.shadowRadius = 15.0
        cell.addPaymentMethodButton.layer.shadowColor = redColor.cgColor
        cell.addPaymentMethodButton.layer.cornerRadius = 25.0
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/
}
