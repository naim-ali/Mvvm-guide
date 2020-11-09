//
//  SignInTableViewController.swift
//  Sagepath
//
//  Created by Sean Davis on 12/5/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class SignInTableViewController: UITableViewController {

    var cell1: PasswordTableViewCell!
    var cell2: TextFieldTableViewCell!
    var cell3: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "textFieldTableViewCell")
        
        cell1 = PasswordTableViewCell(style: .default, reuseIdentifier: "textFieldTableViewCell")
        cell2 = TextFieldTableViewCell(style: .default, reuseIdentifier: "textFieldTableViewCell")
        cell3 = UITableViewCell(style: .default, reuseIdentifier: "textFieldTableViewCell")
        
        self.tableView.separatorColor = UIColor.clear
        
        cell1.textField.placeholder = "********"
        cell1.label.text = "ENTER PASSWORD"
        
        cell2.textField.placeholder = "Email"
        cell2.label.text = "EMAIL ADDRESS"
        
        
        
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch(indexPath.row)
        {
        case 0:
            return cell1
        case 1:
            return cell2
        case 2:
            return cell3
        default:
            return InputTableViewCell(style: .default, reuseIdentifier: "textFieldTableViewCell")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = self.tableView(tableView, cellForRowAt: indexPath) as? InputTableViewCell
        {
            return cell.getCellHeight()
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row)
        {
        case 2:
            return
        default:
            return;
        }
    }
    
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tableView(tableView, cellForRowAt: indexPath).frame.height
//    }

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

}
