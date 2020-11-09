//
//  PushNotificationsViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 3/19/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit


class PushNotificationsViewController: AccountsAbstractController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationTitle: NavigationLabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var goBack: UIImageView!
    
    @IBOutlet weak var globalNotificationLabel: UILabel!
    @IBOutlet weak var globalNotificationSwitch: UISwitch!
    
    @IBOutlet weak var hotLightLabel: UILabel!
    
    @IBAction func toggleMessagePush(_ sender: Any) {
        let apd = (UIApplication.shared.delegate as! AppDelegate)
        apd.msn = !apd.msn
        globalNotificationSwitch.setOn(apd.msn, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
        
        goBack.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        goBack.isUserInteractionEnabled = true
        
        tableView.register(UINib(nibName: "PushNotificationCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 50
        
        tableView.tableHeaderView = tableHeader
        let apd = (UIApplication.shared.delegate as! AppDelegate)
        globalNotificationSwitch.setOn(apd.msn, animated: true)
        
        globalNotificationLabel.textColor = Project.Colors.darkGreen
        globalNotificationLabel.font = UIFont(name: "Brandon Grotesque", size: 14.0)
        globalNotificationLabel.textAlignment = .center
        lightLabel.adjust(characterSpacing: nil, lineHeight: 21, alignment: nil)
        
        hotLightLabel.font = UIFont(name: "Brandon Grotesque", size: 18.0)
        
        if (viewModel?.authentication.value.isAuthorized)! {
            viewModel?.getSubscriptions()
        }
        
        _ = viewModel?.shops.observeNext { value in
            //if ( self.viewModel!.subscriptions.count > 0 ) {
                DispatchQueue.main.async() {
                    print("sops from model ",self.viewModel.shops)
                    self.tableView.reloadData()
                }
            //}
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.shops.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchHotLightToggle(_ on : Bool, shopId: NSNumber) {
        viewModel?.changeSubscription(shopId: shopId, subscribe: on)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! PushNotificationCell
        
        cell.storeName.text = self.viewModel.shops[indexPath.row].shopName
        
        cell.storeName.text = cell.storeName.text?.uppercased()
        cell.toggle.setOn(true, animated: false)
        cell.toggle.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        cell.favorited.contentMode = .scaleAspectFit
        cell.favorited.isHidden = true
        
        let shop = viewModel.shops[indexPath.row]
        if shop.shopName == (UIApplication.shared.delegate as! AppDelegate).authentication.value.favoriteShop.value?.shopName {
            cell.favorited.isHidden = false
        }
        return cell
    }
    
    @objc func switchChanged(toggle: UISwitch) {
        
        if let cell = toggle.superview?.superview as? PushNotificationCell {
            let indexPath = tableView.indexPath(for: cell)
            let body = KKUpdateSubscriptionRequest()
            body?.customerId = (UIApplication.shared.delegate as! AppDelegate).authentication.value.customerId
            body?.deviceId = "test"
            body?.shopId = self.viewModel.shops[indexPath!.row].shopId!
            body?.subscribe = toggle.isOn ? true : false
            self.viewModel.updateSubscription(body!)
        }
    
        
        // Do something
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
