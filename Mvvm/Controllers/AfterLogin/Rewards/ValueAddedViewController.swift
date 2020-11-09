//
//  ValueAddedViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/12/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class ValueAddedViewController: UIViewController {

    var valueAdded:String?
    @IBOutlet weak var confirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let value = valueAdded {
            confirmationLabel.text = "\(value) WAS ADDED TO YOUR KRISPY KREME REWARDS CARD!"
        }
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
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
