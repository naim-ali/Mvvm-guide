//
//  SideMenuRootTableViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/6/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    weak var baseNavigationCoordinator : BaseNavigationViewControllerDelegate?
    var menuButtonLeadingConstraint = NSLayoutConstraint()
    var sideMenuAnimator:SideMenuAnimator?
    var sideMenu:SideMenuViewController!
    
    var navContainer:PassThroughView!
    
    @IBOutlet var menuButtonContainer:UIImageView!
    var menuButton:UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
       
//        sideMenuAnimator = SideMenuAnimator(baseViewController: self.presentingViewController as? BaseNavigationViewController)
//        print(self.presentingViewController?.description)
//        //let menu = (UIApplication.shared.delegate as! AppDelegate).authentication.isAuthorized.value ? "authenticatedSideMenu" : "guestSideMenu"
//        let sideMenu = self
//        sideMenu.coordinator = baseNavigationCoordinator
//        sideMenu.transitioningDelegate = sideMenuAnimator
//        //present(sideMenu, animated: true, completion: nil)
//
//        dismiss(animated: true, completion: nil)
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func messagesButtonTapped(_ sender: Any) {
        baseNavigationCoordinator?.messages(viewController: self)
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        baseNavigationCoordinator?.home(viewController: self)
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: false)
        baseNavigationCoordinator?.signUp(viewController: self)
    }
    
    @IBAction func findAShopButtonTapped(_ sender: Any) {
        self.baseNavigationCoordinator?.findAShop(viewController: self)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func myAccountButtonTapped(_ sender: Any) {
        self.baseNavigationCoordinator?.myAcccount(viewController: self)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    private func setupUI() {
        setupNavContainer()
        setupMenuButton()
    }
    
    private func setupNavContainer() {
        let containerWidth = SideMenuAnimator.sharedInstance.whiteTabContainer.image?.size.width
        navContainer = PassThroughView()
        navContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navContainer)
        navContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        navContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  (containerWidth! * 2.7) ).isActive = true
        navContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navContainer.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
    }
    
    
    private func setupMenuButton() {
        
        menuButtonContainer = SideMenuAnimator.sharedInstance.whiteTabContainer
        self.view.addSubview(menuButtonContainer)
        menuButtonContainer.leadingAnchor.constraint(equalTo: navContainer.leadingAnchor, constant: -2).isActive = true
        menuButtonContainer.topAnchor.constraint(equalTo: navContainer.topAnchor).isActive = true
        menuButtonContainer.bottomAnchor.constraint(equalTo: navContainer.bottomAnchor).isActive = true
        menuButtonContainer.widthAnchor.constraint(equalToConstant: 185.0).isActive = true
        //menuButtonContainer.widthAnchor.constraint(equalToConstant: 185.0).isActive = true
        
        // load the menu animations in the background
        
        menuButton = UIButton()
        menuButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchDown)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuButton)
//        menuButtonLeadingConstraint = self.menuButtonContainer.leadingAnchor.constraint(equalTo: self.menuButtonContainer.leadingAnchor)
//        menuButtonLeadingConstraint.isActive = true
        menuButton.leadingAnchor.constraint(equalTo: menuButtonContainer.leadingAnchor, constant: 90).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        menuButton.topAnchor.constraint(equalTo: menuButtonContainer.topAnchor, constant: 65.0).isActive = true
        menuButton.setImage(UIImage(named: "Arrow Icon Red"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFill
    }
    
    //
    
    // MARK: - Button events
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
