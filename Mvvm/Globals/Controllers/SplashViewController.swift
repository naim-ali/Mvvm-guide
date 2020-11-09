//
//  SplashViewController.swift
//  Mvvm
//
//  Created by Sagepath on 2/12/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

protocol SplashViewControllerDelegate: class {
    func viewDidAppear(splashViewController: SplashViewController)
}

class SplashViewController : UIViewController {
    
    weak var coordinator: SplashViewControllerDelegate?
    override func viewDidAppear(_ animated: Bool) {
        self.coordinator?.viewDidAppear(splashViewController: self)
    }
    
    override func viewDidLoad() {
        
    }
    
    @IBOutlet var background : UIView!
    @IBOutlet var splash: UIImageView!
}
