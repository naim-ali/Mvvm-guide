//
//  AccountCoordinator.swift
//  Mvvm
//
//  Created by Sagepath on 3/14/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

protocol AccountCoordinatorDelegate: BaseNavigationCoordinatorDelegate {
}

class AccountCoordinator: BaseNavigationCoordinator {
    
    weak var coordinator: AccountCoordinatorDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    
    var viewModel : AccountViewModel!
    
    let storyboard = UIStoryboard(name: "Account", bundle: nil)
    let slideFadeAnimator = SlideFadeAnimator()
    
    override func start() {
            let accountController = self.storyboard.instantiateInitialViewController() as! AccountViewController
            accountController.coordinator = self
            
            self.navigationController.delegate = self.slideFadeAnimator
            self.navigationController.pushViewController(accountController, animated: true)
        
            self.viewModel = AccountViewModel()
            viewModel.client = KKAPIClient.default()
    }
}


extension AccountCoordinator: AccountViewControllerDelegate {
    func signOut(accountViewController: AccountViewController) {
        self.authentication.value = Authentication()
        self.coordinator?.navigate(baseNavigationCoordinator: self, target: .Home)
    }
    
    //these can be broken into a single method
    func paymentMethods(accountViewController: AccountViewController){
        let viewController = storyboard.instantiateViewController(withIdentifier: "paymentMethodsController")as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func profileSecurity(accountViewController: AccountViewController){
        let viewController = storyboard.instantiateViewController(withIdentifier: "securityController") as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func changePassword(accountViewController: AccountViewController) {
        let viewController = storyboard.instantiateViewController(withIdentifier: "changePasswordController") as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func termsOfUse(accountViewController: AccountViewController){
        let viewController = storyboard.instantiateViewController(withIdentifier: "termsController") as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func privacyPolicy(accountViewController: AccountViewController){
        let viewController = storyboard.instantiateViewController(withIdentifier: "privacyPolicyController") as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func addPaymentMethod(accountViewController: AccountViewController){
        let viewController = storyboard.instantiateViewController(withIdentifier: "addPaymentMethodController") as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func notifications(accountViewController: AccountViewController){
        let viewController = storyboard.instantiateViewController(withIdentifier: "notificationsController") as? AccountsAbstractController
        viewController?.accountController = accountViewController
        viewController?.viewModel = viewModel
        accountViewController.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func favoriteShop(accountViewController: AccountViewController){
            let shopFinderCoordinator = ShopFinderCoordinator(window: self.window, navigationController: self.navigationController)
        shopFinderCoordinator.backToAccount = true
            shopFinderCoordinator.coordinator = super.baseNavigationCoordinator as? ShopFinderCoordinatorDelegate
            addChildCoordinator(shopFinderCoordinator)
            let shopId = (UIApplication.shared.delegate as! AppDelegate).authentication.value.favoriteShop.value?.shopId
            shopFinderCoordinator.selectShop(shopId: shopId)
    }
}
