//
//  MessagesCoordinator.swift
//  Mvvm
//
//  Created by Naim Ali on 4/3/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

protocol MessagesCoordinatorDelegate: BaseNavigationCoordinatorDelegate {
    
}

class MessagesCoordinator: BaseNavigationCoordinator {
    
    weak var coordinator: HomeCoordinatorDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    
    let slideFadeAnimator = SlideFadeAnimator()
    
    override func start() {
        let messagesViewModel = MessagesViewModel()
        messagesViewModel.client = KKAPIClient.default()
        
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let messagesViewController = storyboard.instantiateViewController(withIdentifier: "messagesController") as! MessagesViewController
        messagesViewController.coordinator = self 
        messagesViewController.viewModel = messagesViewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(messagesViewController, animated: true)
    }

}


extension MessagesCoordinator: MessagesViewControllerDelegate {
    
}
