//
//  AuthCoordinator.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol BaseNavigationCoordinatorDelegate: class {
    func navigate(baseNavigationCoordinator: BaseNavigationCoordinator, target: NavigationTarget)
}

class BaseNavigationCoordinator: BaseCoordinator {
    weak var baseNavigationCoordinator: BaseNavigationCoordinatorDelegate?
}

extension BaseNavigationCoordinator : BaseNavigationViewControllerDelegate {
    func myAcccount(viewController: UIViewController) {
        baseNavigationCoordinator?.navigate(baseNavigationCoordinator: self, target: .MyAccount)
    }
    
    func home(viewController: UIViewController) {
        baseNavigationCoordinator?.navigate(baseNavigationCoordinator: self, target: .Home)
    }
    
    func signUp(viewController: UIViewController) {
        baseNavigationCoordinator?.navigate(baseNavigationCoordinator: self, target: .SignUp)
    }
    
    func findAShop(viewController: UIViewController) {
        baseNavigationCoordinator?.navigate(baseNavigationCoordinator: self, target: .FindAShop)
    }
    
    func messages(viewController: UIViewController) {
        baseNavigationCoordinator?.navigate(baseNavigationCoordinator: self, target: .Messages)
    }
}


