////
//  AuthCoordinator.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Bond
import Foundation
import UIKit

class BaseCoordinator: RootCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    var authentication: Observable<Authentication> {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.authentication
    }
    
    let window: UIWindow
    
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    init(window: UIWindow, navigationController: UINavigationController?) {
        self.window = window
        if (navigationController != nil) {
            self.navigationController = navigationController!
        }
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() { }
}

