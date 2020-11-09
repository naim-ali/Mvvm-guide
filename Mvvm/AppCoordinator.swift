//
//  AppCoordinator.swift
//
//  Created by Will Townsend on 11/11/16.
//  Copyright © 2016 Will Townsend. All rights reserved.
//
import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    override func start() {
        // load second, fake splash screen so that we can animate from it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashViewController = storyboard.instantiateInitialViewController() as! SplashViewController
        splashViewController.coordinator = self
        self.navigationController.pushViewController(splashViewController, animated: false)
    }
}

extension AppCoordinator : SplashViewControllerDelegate {
    func viewDidAppear(splashViewController: SplashViewController) {
        let authCoordinator = AuthCoordinator(window: self.window, navigationController: self.navigationController)
        authCoordinator.coordinator = self
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
}

extension AppCoordinator : AuthCoordinatorDelegate {
    func authComplete(authCoordinator: AuthCoordinator) {
        removeChildCoordinator(authCoordinator);
        
        let homeCoordinator = HomeCoordinator(window: self.window, navigationController: self.navigationController)
        homeCoordinator.coordinator = self
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
}

extension AppCoordinator: BaseNavigationCoordinatorDelegate {
    func navigate(baseNavigationCoordinator: BaseNavigationCoordinator, target: NavigationTarget) {
        switch target {
        case .Home:
            let homeCoordinator = HomeCoordinator(window: self.window, navigationController: self.navigationController)
            homeCoordinator.coordinator = self
            addChildCoordinator(homeCoordinator)
            homeCoordinator.start()
        case .SignUp:
            let authCoordinator = AuthCoordinator(window: self.window, navigationController: self.navigationController)
            authCoordinator.coordinator = self
            addChildCoordinator(authCoordinator)
            authCoordinator.signUp()
        case .FindAShop:
            let shopFinderCoordinator = ShopFinderCoordinator(window: self.window, navigationController: self.navigationController)
            shopFinderCoordinator.coordinator = self
            addChildCoordinator(shopFinderCoordinator)
            shopFinderCoordinator.start()
        case .MyAccount:
            let accountCoordinator = AccountCoordinator(window: self.window, navigationController: self.navigationController)
            accountCoordinator.coordinator = self
            addChildCoordinator(accountCoordinator)
            accountCoordinator.start()
        case .Messages:
            let messagesCoordinator = MessagesCoordinator(window: self.window, navigationController: self.navigationController)
            messagesCoordinator.coordinator = self
            addChildCoordinator(messagesCoordinator)
            messagesCoordinator.start()
        }
        
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func shopSelected(homeCoordinator: HomeCoordinator, shopId: NSNumber?) {
        let shopFinderCoordinator = ShopFinderCoordinator(window: self.window, navigationController: self.navigationController)
        shopFinderCoordinator.coordinator = self
        addChildCoordinator(shopFinderCoordinator)
        shopFinderCoordinator.selectShop(shopId: shopId)
    }
}

extension AppCoordinator: AccountCoordinatorDelegate {
}

extension AppCoordinator: ShopFinderCoordinatorDelegate {
}
