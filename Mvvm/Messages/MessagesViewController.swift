//
//  MessagesViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 4/3/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

protocol MessagesViewControllerDelegate: BaseNavigationViewControllerDelegate {
}

class MessagesViewController: BaseNavigationViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationTitle: NavigationLabel!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var goBack: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MessagesViewControllerDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    var viewModel: MessagesViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
        
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        viewModel?.getmessages()
        
        _ = viewModel?.messages.observeNext { value in
            if ( self.viewModel!.messages.count > 0 ) {
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! MessageCell
        let msg = viewModel?.messages[indexPath.row] as AnyObject
        print(msg, "MESSAGE!")
        cell.title.text = msg.object(forKey: "title") as? String
        cell.body.text = msg.object(forKey: "body") as? String

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
            return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let body = KKRemovePaymentMethodRequest()
//            body?.customerId = self.viewModel.paymentMethods[indexPath.row-1].customerId
//            body?.paymentMethodId = self.viewModel.paymentMethods[indexPath.row-1].paymentMethodId
//            viewModel.removePaymentMethod(body!, index: indexPath.row - 1)
//
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
    }

}
