//
//  HomeCoordinator.swift
//
//  Created by Sagepath on 2/10/18.
//  Copyright © 2018 Naim Ali. All rights reserved.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate: BaseNavigationCoordinatorDelegate {
    func shopSelected(homeCoordinator: HomeCoordinator, shopId: NSNumber?)
}

class HomeCoordinator: BaseNavigationCoordinator {
    
    weak var coordinator: HomeCoordinatorDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    
    let slideFadeAnimator = SlideFadeAnimator()
    
    override func start() {
        let homeViewModel = HomeViewModel()
        homeViewModel.client = KKAPIClient.default()
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        homeViewController.coordinator = self
        homeViewController.viewModel = homeViewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(homeViewController, animated: true)
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    func shopSelected(homeViewController: HomeViewController, shopId: NSNumber?) {
        coordinator?.shopSelected(homeCoordinator: self, shopId: shopId)
    }
}
