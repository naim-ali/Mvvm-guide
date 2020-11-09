//
//  AccountViewController.swift
//  Mvvm
//
//  Created by Sagepath on 3/14/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

protocol AccountViewControllerDelegate: BaseNavigationViewControllerDelegate{
    func signOut(accountViewController: AccountViewController)
    func termsOfUse(accountViewController: AccountViewController)
    func changePassword(accountViewController: AccountViewController)
    func profileSecurity(accountViewController: AccountViewController)
    func paymentMethods(accountViewController: AccountViewController)
    func addPaymentMethod(accountViewController: AccountViewController)
    func notifications(accountViewController: AccountViewController)
    func favoriteShop(accountViewController: AccountViewController)
    func privacyPolicy(accountViewController: AccountViewController)
}

class AccountViewController: BaseNavigationViewController ,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var navigationBar: UIView!
    
    @IBOutlet weak var navigationTitle: NavigationLabel!
    
    weak var coordinator: AccountViewControllerDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    //var viewModel: AccountViewModel?

    @IBAction func signOut(_ sender: UIButton) {
        self.coordinator?.signOut(accountViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainButton?.isHidden = true
        self.tableView = self.childViewControllers[0].view as! UITableView
        self.tableView.delegate = self
        self.tableView.rowHeight = 60
        self.tableView.tableFooterView = UIView()
        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.coordinator?.paymentMethods(accountViewController: self)
        case 1:
            self.coordinator?.profileSecurity(accountViewController: self)
        case 2:
            self.coordinator?.notifications(accountViewController: self)
        case 3:
            self.coordinator?.favoriteShop(accountViewController: self)
        case 4:
            self.coordinator?.privacyPolicy(accountViewController: self)
        case 5:
            self.coordinator?.termsOfUse(accountViewController: self)
        default:
            print(" ")
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! LocationCell
        
        return cell
    }
}
