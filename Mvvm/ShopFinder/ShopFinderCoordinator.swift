//
//  ShopFinderCoordinator.swift
//  Mvvm
//
//  Created by Sagepath on 3/6/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

protocol ShopFinderCoordinatorDelegate: BaseNavigationCoordinatorDelegate {
    
}

class ShopFinderCoordinator: BaseNavigationCoordinator {
    
    weak var coordinator: ShopFinderCoordinatorDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    
    var backToAccount = false
    
    let slideFadeAnimator = SlideFadeAnimator()
    
    override func start() {
        let shopFinderViewModel = ShopFinderViewModel()
        shopFinderViewModel.client = KKAPIClient.default()
        
        let storyboard = UIStoryboard(name: "ShopFinder", bundle: nil)
        let shopFinderViewController = storyboard.instantiateViewController(withIdentifier: "shopFinder") as! ShopFinderController
        shopFinderViewController.coordinator = self
        shopFinderViewController.viewModel = shopFinderViewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(shopFinderViewController, animated: true)
    }
    
    func toAccount() {
        if self.backToAccount {
            self.navigationController.popViewController(animated: true)
        }
        //self.baseNavigationCoordinator?.myAcccount(viewController: self)
//        let accountCoordinator = AccountCoordinator(window: self.window, navigationController: self.navigationController)
//        accountCoordinator.coordinator = super.baseNavigationCoordinator as? AccountCoordinatorDelegate
//        addChildCoordinator(accountCoordinator)
//        accountCoordinator.start()
        
    }
    
    func selectShop(shopId: NSNumber?) {
        let shopFinderViewModel = ShopFinderViewModel()
        shopFinderViewModel.client = KKAPIClient.default()
        
        let storyboard = UIStoryboard(name: "ShopFinder", bundle: nil)
        let shopFinderViewController = storyboard.instantiateViewController(withIdentifier: "shopFinder") as! ShopFinderController
        shopFinderViewController.coordinator = self
        shopFinderViewController.viewModel = shopFinderViewModel
        
        if (shopId != nil) {
            shopFinderViewModel.getShop(shopId: shopId)
        }
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(shopFinderViewController, animated: true)
    }
}

extension ShopFinderCoordinator: ShopFinderControllerDelegate {

}

